# Contributing to the mlr3book

Thank you for contributing to *Applied Machine Learning Using mlr3 in R*!
This document covers everything you need to know before writing or editing a chapter.

## Rendering the Book

1. Clone this repository and navigate to the `mlr3book` directory.
2. Pull the Docker image: `docker pull mlrorg/mlr3-book`.
3. Preview the book:

```bash
docker run --name mlr3book \
 -v $(pwd):/mlr3book_latest \
 --rm \
 -p 8888:8888 \
 mlrorg/mlr3-book quarto preview mlr3book_latest/book --port 8888 --host 0.0.0.0 --no-browser
```

Access the preview at `http://0.0.0.0:8888`. Add `--cache-refresh` to force a cache refresh.
To speed this up, comment out the other chapters in `book/_quarto.yml`.

Before opening a pull request, run the [mlr3book-reviewer](https://github.com/mlr-org/actions/tree/main/skills/mlr3book-reviewer) Claude skill to automatically check your changes against the style and structure guide.

Once you are happy with your changes, open a pull request. The pull request will include a preview of your changes.

If your changes require new packages, install them temporarily in the Docker image:

```r
remotes::install_github("mlr-org/mlr3extralearners")
remotes::install_cran("qgam")
```

Add these lines temporarily at the beginning of the new chapter. Once the pull request is accepted, add the packages to the mlr3-book Dockerfile at [mlr-org/mlr3docker](https://github.com/mlr-org/mlr3docker) and remove the installation calls.

## Corrections

When corrections are made to chapters included in the first published edition, document them in the *Errata* appendix.

## Chapter Structure

Each chapter (except the preamble, introduction, and appendix) must be structured as follows.

### Front Matter

Include the following metadata in the front matter of each chapter:

- Chapter authors (name, affiliation, ORCID)
- A 150–200 word abstract

New chapters not present in the published edition should be marked with a `+` in the title.
Early-stage chapters that have not yet been rigorously edited and reviewed should be additionally marked as *Draft*.
Online-only chapters must wrap their content in the following block:

```qmd
::: {.content-visible when-format="html"}
...
:::
```

### Setup

Add `{{< include _setup.qmd >}}` at the start of each chapter. Do **not** call `set.seed()` anywhere in the chapter body; it may only appear inside exercises at the end.

### Introduction

The introduction must cover:

- What the chapter covers.
- Why the chapter is important.
- The theoretical background of the topic.

Use formulae conservatively — avoid them if possible.

If a chapter contains a few distinct and complex subsections, introduce each subsection directly before it rather than explaining everything at the top of the chapter. For example, a chapter on hyperparameter optimization covering tuning, multi-criteria optimization, and nested resampling should introduce only tuning in the opening introduction, and introduce the other topics immediately before their respective sections.

### Conclusion

The conclusion must include:

- Key takeaways from the chapter, covering both core theoretical methods and corresponding code.
- A mini-API table linking sugar functions to their R6 equivalents.
- Pointers to further reading in the literature.
- Links to high-quality mlr3 gallery posts with a brief explanation of why the reader should read them.
- Exercises and solutions.

See the [HPO chapter](https://mlr3book.mlr-org.com/optimization.html#conclusion) as a reference example.

## Style Guide

### R Code

- Follow the mlr3 style guide (explained in the preamble): use `=` for assignment, not `<-`.
- Use `mtcars` for regression examples and `penguins` for classification examples.
The appendix shows `str()` and `head()` of these datasets — do not repeat this in the text. Post an issue if you genuinely need a different dataset.
- Always use named arguments for optional parameters, e.g. `as_task_regr(mtcars, "mpg", id = "cars")`.
- Use sugar functions in the main body of text.
- Avoid comments inside code chunks. Explain what the code does in the surrounding text instead.
- Do not shadow function names with variable names. For example, never name a learner object `lrn`.
- Ensure every code chunk is explained in the surrounding text.

### English

- Do not use contractions (e.g. write "do not" instead of "don't").
- Refer to "R6" rather than "R6 Classes" unless explicitly discussing programming paradigms.
- Check the [glossary](https://mlr3book.mlr-org.com/glossary.html) before introducing terms to avoid duplicates or inconsistent usage. Add new terms to the glossary as you go.

### Quarto

**Inline formatting:**

| What | Syntax |
|---|---|
| Package name | `` `package` `` |
| Function from a package | `` `package::function()` `` |
| Function (unqualified) | `` `function()` `` |
| R6 field | `` `$field` `` |
| R6 method | `` `$method()` `` |

**Numbers:** Use no formatting for plain numbers unless the number appears in code (`` `1` ``) or a mathematical expression ($1$).

**Links:**

- Avoid external hyperlinks unless strictly required. When required, use the `` `r link()` `` function.
- Never use bare markdown links for internal sections, e.g. `[some topic](#topic)`. Always use `@sec-...` cross-references instead.
- When referencing functions outside the mlr3verse — or where ambiguity is possible — include the package prefix, e.g. write `paradox::to_tune` rather than `to_tune`.
- Link packages using `` `r ref_pkg("package")` ``, or `` `r mlr3` `` for mlr3 ecosystem packages.
- Link each package or function only once per `##` subsection.

**Cross-references:** All tables, figures, and other floats must have a caption and a reference key. The key must match the float type: `tbl-` for tables, `fig-` for figures.

**Referencing mlr3 objects:**

- Learners: `` `r lrn("regr.featureless")` ``
- Measures: `` `r msr("regr.rmse")` ``

**Sections:** Mark optional or advanced sections by adding `{{< include _optional.qmd >}}` on a new line immediately after the section title (leave a blank line between them).

**Definitions and index entries:**

- Use `` `r define("benchmark")` `` to define a new term. This prints the term, adds an index entry, and highlights the term in the margin.
- Use `` `r index("benchmark")` `` to add an index entry for a term without a full definition.

**Figures:**

- Use `` #| fig-alt: `` in the chunk front matter to add alternative text for figures (not the same as the caption — describe what is shown for screen-reader users).
- Use `%%| alt-text: ` in the front matter of Mermaid diagrams for the same purpose.
- Where possible, use SVG for HTML figures and PDF for print figures. Include them with `knitr::include_graphics()` or the [`include_multi_graphics()`](https://github.com/mlr-org/mlr3book/blob/main/book/common/_utils.qmd) helper.

**Callout boxes:**

| Type | Syntax | When to use |
|---|---|---|
| Warning | `:::{.callout-warning} :::` | Important exceptions readers should be aware of, e.g. common mistakes or incorrect usage patterns |
| Tip | `:::{.callout-tip} :::` | Optional useful points, advanced notes, or supplementary information about code |
| Note | `:::{.callout-note} :::` | **Never** use directly. Use `{{< include _optional.qmd >}}` to mark optional subsections instead |
| Important | `:::{.callout-important} :::` | **Never** use |
| Caution | `:::{.callout-caution} :::` | **Never** use |







