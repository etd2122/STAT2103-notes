# STAT 2103 · Applied Linear Regression notebook

Course site for STAT UN2103 Applied Linear Regression (Columbia, Fall 2026): handwritten lecture notes, homework sets, and the class R examples, organized by date.

**Live site:** https://etd2122.github.io/STAT2103-notes/

## What's here

| Folder | Contents |
| --- | --- |
| `notes/` | Scanned lecture notes, one PDF per class (`YYYY-MM-DD-topic.pdf`) |
| `assignments/` | Homework 1–4 PDFs |
| `code/` | Each R example as a runnable `.R` script, prose kept as comments |
| `examples/` | The original rendered R notebooks (HTML, with output and plots) |
| `thumbs/` | First-page previews used on the site |
| `index.html` | The site itself (no build step) |

## Publish on GitHub Pages

1. Create a new repository on GitHub (for example `stat2103-notes`).
2. Upload everything in this folder to it (drag the files into **Add file → Upload files**, or `git push`).
3. Go to **Settings → Pages**, set **Source** to *Deploy from a branch*, choose `main` and `/ (root)`, and save.
4. The site appears at `https://<your-username>.github.io/stat2103-notes/` within a minute or two.

## Adding a new lecture, homework, or example

Everything on the page comes from three lists near the bottom of `index.html`:

- `LEC` — lectures. Add `{d:"Oct 14", dow:"Wed", slug:"2026-10-14-topic", t:"Title", p:PAGES, desc:"One line", ex:[], hw:[]}` and drop `notes/2026-10-14-topic.pdf` plus a `thumbs/2026-10-14-topic.jpg` preview.
- `HW` — homework. Add `{n:5, p:PAGES, topics:[...], data:[...]}` with `assignments/hw5.pdf` and `thumbs/hw5.jpg`.
- `EX` — R examples. Add a key matching `code/<key>.R` and `examples/<key>.html`.

Make a thumbnail with: `pdftoppm -r 50 -jpeg -f 1 -l 1 -singlefile notes/FILE.pdf thumbs/FILE`

## Data files

Some scripts read data that isn't included: `academics.csv` (simulating-regression) and `language.Rdata` (slr-inference); the homeworks use `scores.csv`, `cars.csv`, and `hurricanes.csv`. Put them in a `data/` folder and point the file paths in the scripts there.
