### Book Overview

The mlr3book is a Quarto-based book about the mlr3 R package ecosystem.
It was originally published in print by CRC Press and is also available online.
Chapters added after the print release are marked with `(+)` in the title.
Early-stage chapters not yet rigorously reviewed are additionally marked as *Draft*.

### Project Structure

- `book/chapters/chapter{N}/` — chapter content (`.qmd` files)
- `book/chapters/appendices/` — appendices including `errata.qmd`
- `book/common/_setup.qmd` — shared setup included at the top of every chapter
- `book/common/_utils.qmd` — helper functions (`authors()`, `citeas()`, `include_multi_graphics()`)
- `book/common/_optional.qmd` — callout block included after optional/advanced sections
- `book/common/chap_auths.csv` and `book/common/authors.csv` — chapter author metadata
- `R/links.R` — helper functions: `ref()`, `ref_pkg()`, `link()`, `index()`, `define()`
- `R/name_chunks.R` — chunk naming utility

### Chapter Structure Rules

Every chapter `.qmd` file must have:

1. **YAML front matter** at the top.
2. **`{{< include ../../common/_setup.qmd >}}`** immediately after the chapter heading — never add `set.seed()` at the top level; it belongs only inside exercises if needed.
3. **`` `r chapter = "Chapter Title"` ``** and **`` `r authors(chapter)` ``** to display author information.
4. **Abstract** — 150 to 200 words, in the front matter or opening.
5. **Introduction** covering: what will be covered, why it matters, theoretical background, and formulae used conservatively. If the chapter has several substantially different subsections, the introduction should cover only the first subsection and each subsequent subsection gets its own short intro.
6. **Conclusion** containing: key takeaways, mini API table (sugar functions to R6 classes), further reading, gallery links with descriptions, and exercises with solutions.

### New and Online-Only Chapters

- New chapters not in the original print edition: mark title with `(+)`.
- Early-stage chapters: additionally mark as *Draft*.
- Online-only chapters: wrap entire content in `::: {.content-visible when-format="html"}`.
- Changes to existing content should be listed in `book/chapters/appendices/errata.qmd`.

### R Code Rules

- Use `=` for assignment, never `<-`.
- Use `mtcars` for regression tasks and `penguins` (from `palmerpenguins`) for classification tasks. Flag other datasets unless justified.
- All optional arguments must use named argument syntax.
- Use sugar functions (`lrn()`, `tsk()`, `msr()`, `rsmp()`, `trm()`, `po()`) in prose and main examples, not `$new()` constructors.
- No comments in code chunks — explanations go in surrounding text. Exception: very complex code where a brief comment genuinely aids comprehension.
- Do not shadow function names as variable names (e.g., do not name a variable `lrn` or `task`). Use descriptive names: `learner`, `task_iris`, `rr`, `bmr`, etc.
- Every code chunk must have accompanying prose explaining what it does and what the output means.

### English Writing Rules

- Do not write "R6" unless explicitly discussing class paradigms. Write "The `Learner`..." not "The R6 class `Learner`...".
- No contractions: "do not" not "don't", "cannot" not "can't", "it is" not "it's".
- American English, Oxford comma.
- Cross-reference the book's glossary for consistent terminology.

### Quarto and Formatting Rules

**Inline code formatting:**
- Packages: `` `package` `` (e.g., `` `mlr3` ``)
- Functions with package qualifier: `` `package::function()` ``
- Functions (in-package): `` `function()` ``
- R6 fields: `` `$field` ``
- R6 methods: `` `$method()` ``

**Links and references:**
- External URLs: use `` `r link("https://example.com")` `` — the `link()` function takes only a URL parameter.
- API references: use `` `r ref("function()")` `` or `` `r ref("package::function()")` `` for disambiguation.
- Package references: use `` `r ref_pkg("package")` `` for non-mlr3 packages; for mlr3 ecosystem packages use `` `r mlr3` ``, `` `r mlr3tuning` ``, etc. (defined as objects in `R/links.R`).
- Link packages and functions only once per subsection (`##`).
- Cross-reference sections with `@sec-*` syntax, never `[text](#anchor)`.
- Figures: must have `#| label: fig-*`, `#| fig-cap:`, and `#| fig-alt:`.
- Tables: must have `{#tbl-*}` reference key and a caption.

**Terms and indexing:**
- First introduction of a key term: `` `r define("term")` ``.
- Subsequent references for the index: `` `r index("term")` ``.

**Optional/advanced sections:**
- Include `{{< include _optional.qmd >}}` immediately after the section heading.
- Never use `::: {.callout-note}` directly; use the `_optional.qmd` include instead.

**Callout boxes — permitted types only:**
- `::: {.callout-warning}` — important exceptions the reader must not miss.
- `::: {.callout-tip}` — optional useful hints, more advanced notes.
- Never use `::: {.callout-note}`, `::: {.callout-important}`, or `::: {.callout-caution}`.

**Numbers in prose:**
- Plain numbers: no formatting (`1`, not `` `1` `` or `$1$`).
- Code values: backticks. Mathematical quantities: `$...$`.

### Chunk Naming

Code chunks should follow the pattern `[file-name]-[number]` (e.g., `introduction_and_overview-001`).
