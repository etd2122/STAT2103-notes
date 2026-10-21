#!/usr/bin/env python3
"""Build data/site.js from the Markdown files in content/.

Usage (from the repo root):
    cd build && npm install && cd ..
    python3 build/build.py

Sources:
    content/notes/*.md      typed lecture notes
    content/examples/*.md   R example boxes (code is pulled from examples/<key>.html)
    content/homework/*.md   homework guides
"""
import base64, html, json, os, re, subprocess, sys
from markdown_it import MarkdownIt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
J = lambda *p: os.path.join(ROOT, *p)

md = MarkdownIt("commonmark", {"html": True}).enable("table")

# ---------------------------------------------------------------- math
MATH = []  # (tex, display)

def protect(text):
    """Swap code spans and math for placeholders so Markdown leaves them alone."""
    codes = []
    def code_sub(m):
        codes.append(m.group(0)); return f"\x00C{len(codes)-1}\x00"
    text = re.sub(r"`[^`\n]+`", code_sub, text)
    def disp(m):
        MATH.append((m.group(1).strip(), True)); return f"@@M{len(MATH)-1}@@"
    def inl(m):
        MATH.append((m.group(1).strip(), False)); return f"@@M{len(MATH)-1}@@"
    text = re.sub(r"\$\$(.+?)\$\$", disp, text, flags=re.S)
    text = re.sub(r"(?<![\\$])\$(?!\$)(.+?)(?<!\\)\$", inl, text)
    text = re.sub(r"\x00C(\d+)\x00", lambda m: codes[int(m.group(1))], text)
    return text

def render(text, inline=False):
    t = protect(text)
    out = md.renderInline(t) if inline else md.render(t)
    return out

def finish_math(obj, rendered):
    """Replace math placeholders everywhere in the built object."""
    def fix(s):
        return re.sub(r"@@M(\d+)@@", lambda m: rendered[int(m.group(1))], s)
    if isinstance(obj, str): return fix(obj)
    if isinstance(obj, list): return [finish_math(x, rendered) for x in obj]
    if isinstance(obj, dict): return {k: finish_math(v, rendered) for k, v in obj.items()}
    return obj

# ---------------------------------------------------------------- front matter
def split_front(raw):
    m = re.match(r"---\n(.*?)\n---\n(.*)", raw, re.S)
    meta, body = {}, raw
    if m:
        body = m.group(2)
        cur = None
        for line in m.group(1).split("\n"):
            if line.startswith("- ") and cur:
                meta.setdefault(cur, []).append(line[2:].strip())
            elif re.match(r"^\w+:", line):
                k, v = line.split(":", 1); v = v.strip(); cur = k
                meta[k] = v if v else []
    return meta, body

def csv(v): return [x.strip() for x in v.split(",") if x.strip()] if isinstance(v, str) else v

# ---------------------------------------------------------------- notes
BOX_TITLES = {"template": "Template", "def": "Definition", "formula": "Formula", "example": "Example", "tip": "Tip", "r": "In R"}

def notes_body(body, formulas, lec_id):
    lines = body.split("\n"); out = []; i = 0
    while i < len(lines):
        m = re.match(r"^:::(\w+)\s*(.*)$", lines[i])
        if m:
            kind, title = m.group(1), m.group(2).strip()
            j = i + 1; inner = []
            while j < len(lines) and lines[j].strip() != ":::":
                inner.append(lines[j]); j += 1
            inner_md = "\n".join(inner)
            label = BOX_TITLES.get(kind, kind.title())
            head = f'<span class="box-k">{label}</span>' + (f'<span class="box-t">{render(title, True)}</span>' if title else "")
            out.append(f'<div class="box box-{kind}"><div class="box-h">{head}</div>\n\n{render(inner_md)}\n</div>')
            if kind == "formula":
                formulas.append({"lec": lec_id, "title": render(title, True) if title else "", "html": render(inner_md)})
            i = j + 1
        else:
            # collect a run of ordinary lines
            j = i; run = []
            while j < len(lines) and not re.match(r"^:::\w+", lines[j]):
                run.append(lines[j]); j += 1
            out.append(render("\n".join(run)))
            i = j
    html_ = "\n".join(out)
    # give h2 ids for an outline
    toc = []
    def h2(m):
        txt = re.sub("<[^>]+>", "", m.group(1)); slug = re.sub(r"[^a-z0-9]+", "-", txt.lower()).strip("-")
        toc.append({"id": f"{lec_id}-{slug}", "t": m.group(1)}); return f'<h2 id="{lec_id}-{slug}">{m.group(1)}</h2>'
    html_ = re.sub(r"<h2>(.*?)</h2>", h2, html_)
    return html_, toc

# ---------------------------------------------------------------- R examples
def parse_notebook(path, key, imgdir):
    t = open(path, encoding="utf-8").read()
    body = t[t.find("</h1>") + 5:]
    body = re.sub(r"<script.*?</script>", "", body, flags=re.S)
    items = []; nimg = 0
    os.makedirs(imgdir, exist_ok=True)
    pat = r'<h([1-4])[^>]*>(.*?)</h\1>|<p>(.*?)</p>|<pre class="r"><code>(.*?)</code></pre>|<pre><code>(.*?)</code></pre>|<img src="data:image/(\w+);base64,([^"]+)"'
    for m in re.finditer(pat, body, re.S):
        if m.group(2) is not None: items.append(["H", m.group(2)])
        elif m.group(3) is not None:
            inner = m.group(3)
            imgs = list(re.finditer(r'<img src="data:image/(\w+);base64,([^"]+)"', inner))
            if imgs and not re.sub(r"<img[^>]*>", "", inner).strip():
                for im in imgs:
                    nimg += 1; name = f"{key}-{nimg}.png"
                    open(os.path.join(imgdir, name), "wb").write(base64.b64decode(im.group(2)))
                    items.append(["I", name])
                continue
            items.append(["P", inner])
        elif m.group(4) is not None: items.append(["C", html.unescape(m.group(4)).rstrip()])
        elif m.group(5) is not None: items.append(["O", html.unescape(m.group(5)).rstrip()])
        else:
            nimg += 1; name = f"{key}-{nimg}.png"
            open(os.path.join(imgdir, name), "wb").write(base64.b64decode(m.group(7)))
            items.append(["I", name])
    return items

def take(items, spec):
    idx = []
    for part in str(spec).split(","):
        part = part.strip()
        if "-" in part: a, b = part.split("-"); idx += list(range(int(a), int(b) + 1))
        elif part: idx.append(int(part))
    code_lines, imgs = [], []
    for i in idx:
        k, v = items[i]
        if k == "C": code_lines.append(v)
        elif k == "O": code_lines.append("\n".join(re.sub(r"^## ?", "#> ", ln) for ln in v.split("\n")))
        elif k == "I": imgs.append("img/examples/" + v)
    code = "\n".join(code_lines)
    return code, imgs

def parse_boxes(body):
    """Split '## Section' and '### box: Title' blocks with simple key: value fields."""
    sections = []; cur_sec = None; cur = None
    lines = body.split("\n"); i = 0
    while i < len(lines):
        ln = lines[i]
        if ln.startswith("## "):
            cur_sec = {"title": ln[3:].strip(), "boxes": []}; sections.append(cur_sec); cur = None
        elif ln.startswith("### box:"):
            if cur_sec is None: cur_sec = {"title": "", "boxes": []}; sections.append(cur_sec)
            cur = {"title": ln[len("### box:"):].strip(), "explain": []}; cur_sec["boxes"].append(cur)
        elif cur is not None:
            m = re.match(r"^(items|what|key|question|explain|code|idea|walk|pitfall|rknow|paper):\s*(.*)$", ln)
            if m:
                k, v = m.group(1), m.group(2)
                if k == "code":
                    j = i + 1; buf = []
                    if j < len(lines) and lines[j].startswith("```"):
                        j += 1
                        while j < len(lines) and not lines[j].startswith("```"):
                            buf.append(lines[j]); j += 1
                        i = j
                    cur["code"] = "\n".join(buf)
                elif k in ("explain", "walk", "pitfall", "rknow"):
                    cur["_in_explain"] = k; cur.setdefault(k, [])
                else:
                    cur[k] = v; cur["_in_explain"] = False
            elif ln.startswith("- ") and cur.get("_in_explain"):
                cur[cur["_in_explain"]].append(ln[2:].strip())
        i += 1
    for s in sections:
        for b in s["boxes"]: b.pop("_in_explain", None)
    return sections

# ---------------------------------------------------------------- main
def main():
    site = {"notes": [], "examples": [], "homework": [], "formulas": [],
            "datasets": sorted(os.listdir(J("datasets"))) if os.path.isdir(J("datasets")) else []}
    # notes
    for fn in sorted(os.listdir(J("content", "notes"))):
        meta, body = split_front(open(J("content", "notes", fn), encoding="utf-8").read())
        html_, toc = notes_body(body, site["formulas"], meta["id"])
        thumb = "thumbs/" + os.path.basename(meta["pdf"]).replace(".pdf", ".jpg")
        site["notes"].append({
            "id": meta["id"], "type": "lec", "date": meta["date"], "title": meta["title"], "part": meta.get("part", ""),
            "pdf": meta["pdf"], "slides": meta.get("slides", ""), "thumb": thumb, "topics": csv(meta.get("topics", "")), "examples": csv(meta.get("examples", "")),
            "summary": render(meta.get("summary", ""), True), "takeaways": [render(t, True) for t in meta.get("takeaways", [])],
            "html": html_, "toc": toc,
        })
    # examples
    for fn in sorted(os.listdir(J("content", "examples"))):
        meta, body = split_front(open(J("content", "examples", fn), encoding="utf-8").read())
        key = meta["key"]
        items = parse_notebook(J("examples", key + ".html"), key, J("img", "examples"))
        sections = parse_boxes(body)
        n = 0
        for s in sections:
            for b in s["boxes"]:
                n += 1
                code, imgs = take(items, b["items"])
                b.update({"n": n, "code": code, "imgs": imgs, "key": b.get("key", "").lower() == "true",
                          "what": render(b.get("what", ""), True), "explain": [render(x, True) for x in b["explain"]],
                          "title": render(b["title"], True)})
                b.pop("items", None)
        site["examples"].append({
            "id": meta["id"], "type": "rex", "key": key, "title": meta["title"], "lecture": meta.get("lecture", ""),
            "topics": csv(meta.get("topics", "")), "summary": render(meta.get("summary", ""), True),
            "takeaways": [render(t, True) for t in meta.get("takeaways", [])],
            "notebook": f"examples/{key}.html", "script": f"code/{key}.R", "sections": sections,
        })
    # homework and practice exams share one format
    site.setdefault("practice", [])
    for folder, kind, key in (("homework", "hw", "homework"), ("practice", "prac", "practice")):
        if not os.path.isdir(J("content", folder)): continue
        for fn in sorted(os.listdir(J("content", folder))):
            meta, body = split_front(open(J("content", folder, fn), encoding="utf-8").read())
            wrap_html = ""
            if "\n=== wrap-up ===" in body:
                body, wrap_md = body.split("\n=== wrap-up ===", 1)
                wrap_html, _ = notes_body(wrap_md, [], meta["id"])
            sections = parse_boxes(body)
            n = 0
            for s in sections:
                for b in s["boxes"]:
                    n += 1
                    b.update({"n": n, "question": render(b.get("question", ""), True),
                              "explain": [render(x, True) for x in b["explain"]], "title": render(b["title"], True),
                              "idea": render(b.get("idea", ""), True), "walk": [render(x, True) for x in b.get("walk", [])],
                              "pitfall": [render(x, True) for x in b.get("pitfall", [])],
                              "rknow": [[render(y.strip(), True) for y in (x.split(" :: ", 1) + [""])[:2]] for x in b.get("rknow", [])],
                              "paper": render(b.get("paper", ""), True),
                              "code": b.get("code", ""), "key": str(b.get("key", "")).lower() == "true"})
            site[key].append({
                "id": meta["id"], "type": kind, "num": meta["num"], "title": meta["title"], "pdf": meta["pdf"],
                "solutions": meta.get("solutions", ""),
                "wrap": wrap_html,
                "thumb": "thumbs/" + os.path.basename(meta["pdf"]).replace(".pdf", ".jpg"),
                "lectures": csv(meta.get("lectures", "")), "data": csv(meta.get("data", "")),
                "topics": csv(meta.get("topics", "")), "summary": render(meta.get("summary", ""), True), "sections": sections,
            })
    # interpretation templates (shown on the Formula sheet page)
    if os.path.exists(J("content", "templates.md")):
        html_, toc = notes_body(open(J("content", "templates.md"), encoding="utf-8").read(), [], "TPL")
        site["templates"] = {"html": html_, "toc": toc}
    if os.path.exists(J("content", "truefalse.md")):
        html_, toc = notes_body(open(J("content", "truefalse.md"), encoding="utf-8").read(), [], "TF")
        site["truefalse"] = {"html": html_, "toc": toc}
    # math → MathML
    if MATH:
        res = subprocess.run(["node", J("build", "render-math.js")], input=json.dumps([{"tex": t, "display": d} for t, d in MATH]),
                             capture_output=True, text=True, cwd=J("build"))
        if res.stderr: sys.stderr.write(res.stderr)
        rendered = json.loads(res.stdout)
        site = finish_math(site, rendered)
    os.makedirs(J("data"), exist_ok=True)
    with open(J("data", "site.js"), "w", encoding="utf-8") as f:
        f.write("// Generated by build/build.py from content/. Edit the Markdown there, then rebuild.\n")
        f.write("window.SITE = " + json.dumps(site, ensure_ascii=False) + ";\n")
    print(f"notes {len(site['notes'])}, examples {len(site['examples'])} "
          f"({sum(len(s['boxes']) for e in site['examples'] for s in e['sections'])} boxes), "
          f"homework {len(site['homework'])}, formulas {len(site['formulas'])}, math {len(MATH)}")

if __name__ == "__main__":
    main()
