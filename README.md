# STAT 2103 · Applied Linear Regression study guide

Typed lecture notes, explained R code, and homework guides for STAT UN2103 (Columbia, Fall 2026).

**Live site:** https://etd2122.github.io/STAT2103-notes/

## What's on the site

- **Lecture notes (L01–L09):** each handwritten lecture typed up with definitions, formulas, worked examples, and a "Remember for the test" list. The original scanned PDF is linked from each one.
- **R examples (R1–R6):** every class notebook split into boxes. Each box has the code with its output and plots on the left, and "What this does" plus an explanation on the right. A yellow edge marks the boxes most likely to matter on an exam.
- **Homework (HW1–HW4):** each problem with an approach, the notes and R examples to use, and R starter code.
- **Study guide:** all the "Remember for the test" points on one page.
- **Formula sheet:** every formula box from the notes.

## Folders

| Folder | Contents |
| --- | --- |
| `content/notes/` | Typed notes, one Markdown file per lecture |
| `content/examples/` | Box titles and explanations for each R example |
| `content/homework/` | Homework guides |
| `data/site.js` | Generated from `content/` (don't edit by hand) |
| `notes/`, `assignments/` | Original PDFs |
| `examples/`, `code/` | Original R notebooks (HTML) and plain `.R` scripts |
| `img/examples/`, `thumbs/` | Plots and PDF previews |
| `build/` | The build script |

## Editing

1. Edit the Markdown in `content/`.
   - Notes use `$...$` for math and `:::formula Title` … `:::` for boxes (`def`, `formula`, `example`, `tip`, `r`).
   - Example boxes start with `### box: Title`, then `items:` (which code/output/plots from the notebook to include), `what:`, `key: true` for exam-important, and `explain:` followed by `- bullet` lines.
2. Rebuild (needs Python 3 with `markdown-it-py`, and Node):
   ```
   cd build && npm install && cd ..
   pip install markdown-it-py
   python3 build/build.py
   ```
3. Commit and push. GitHub Pages updates in a minute or two.

## Data files

`datasets/` holds the homework data uploaded so far: `hurricanes.csv` (HW4, HW5), `plants.csv` and `salmonella.csv` (HW5). Each homework page links to its files. Still missing: `scores.csv` (HW1–2), `cars.csv` (HW3), and the class-example data (`hibbs.dat`, `academics.csv`, `language.Rdata`, `rain.csv`). Drop new files into `datasets/` and rebuild, and the links appear automatically.
