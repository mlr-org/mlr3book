# mlr3book

[![Travis build status](https://travis-ci.org/mlr-org/mlr3book.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3book)

Package to build the mlr3 [bookdown](https://bookdown.org/) book.
The rendered book can be found [here](https://mlr-org.github.io/mlr3book/).

To install all necessary dependencies for the book, install the this package using [remotes](https://cran.r-project.org/package=remotes):

```r
remotes::install_github("mlr-org/mlr3book", dependencies = TRUE)
```

To build the book, run the following R command in the repository root:

```r
pkgload::load_all()
serve_mlr3book()
```

This starts a service which automatically (re-)compiles the bookdown sources in the background.
Alternatively, you can run `./serve` if you have `Rscript` in your `PATH`.
If your browser does not open automatically, go to http://127.0.0.1:4321/.

## File system structure

The root directory is a regular R package.
The book is in the subdirectory "bookdown".

## Style Guide

### Links and References

The package `mlr3book` provides the helpers `cran_pkg()`, `mlr_pkg()`, `gh_pkg()`, and `ref()`
Example:

```
See the manual for `r ref("Experiment")`.
More learners can be found in `r mlr_pkg("mlr_learners")`.
We heavily use `r cran_pkg("data.table")` internally.
You need the development version of `r gh_pkg("mlr-org/mlr3")` for this.
```

### Chunk Names

Chunks are named automatically as `[chapter-name]-#` by calling `name_chunks_mlr3book()`:

```r
mlr3book::name_chunks_mlr3book()
```

### Blocks

You can add certain ["blocks"](https://bookdown.org/yihui/bookdown/custom-blocks.html) supported by [bookdown](https://github.com/rstudio/bookdown) for notes, warnings, etc.
Start the code chunk with `block` instead of `r` and add `type='caution'`.

````
```{block <name>, type='caution'}
<text>
```
````

### Spacing

- Always start a new sentence on a new line.
- Always start a new sentence on a new line.
- Put an empty line before and after code blocks.
