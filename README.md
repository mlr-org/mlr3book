# mlr3book

[![Build Status](https://img.shields.io/travis/mlr-org/mlr3book/master?label=Linux&logo=travis&style=flat-square)](https://travis-ci.org/mlr-org/mlr3book)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)

Package to build the [mlr3](https://mlr3.mlr-org.com) [bookdown](https://bookdown.org/) book.

## Rendered Versions

- [HTML](https://mlr3book.mlr-org.com)

- [PDF](https://mlr3book.mlr-org.com/mlr3book.pdf)

## Building the book

To install all necessary dependencies for the book, install this R package using [remotes](https://cran.r-project.org/package=remotes):

```r
remotes::install_github("mlr-org/mlr3book", dependencies = TRUE)
```

To build the book, run one of the following commands:

```r
# HTML
withr::with_dir("bookdown", bookdown::render_book("index.Rmd", 
  output_format = "bookdown::gitbook")) 

# PDF
withr::with_dir("bookdown", bookdown::render_book("index.Rmd", 
  output_format = "bookdown::pdf_book")) # PDF
```

### Serve the book

Alternatively, you "serve" the book via a local server:

```r
bookdown::serve_book("bookdown")
```

The command above starts a service which automatically (re-)compiles the bookdown sources in the background whenever a file is modified.
If your browser does not open automatically, go to http://127.0.0.1:4321/.

### Makefile approach

Alternatively, you can use the provided `Makefile` (c.f. see `make help`).
This way, you can

- install dependencies
- build the HTML book -> `make html`
- build the PDF book (`bookdown:pdf_book`) -> `make pdf`

## File system structure

The root directory is a regular R package.
The book itself is in the subdirectory "bookdown".

## Style Guide

### Lists

For lists please use `*` and not `-`.

### Chunk Names

Chunks are named automatically as `[chapter-name]-#` by calling `name_chunks_mlr3book()`:

```r
mlr3book::name_chunks_mlr3book()
```

or alternatively executing `make names` from the terminal.

### Blocks

You can add certain ["blocks"](https://bookdown.org/yihui/bookdown/custom-blocks.html) supported by [bookdown](https://github.com/rstudio/bookdown) for notes, warnings, etc.
Start the code chunk with `block` instead of `r` and add `type='caution'`.

````
```{block <name>, type='caution'}
<text>
```
````

### Figures

Please use `knitr::include_graphics()` to add figures.
This way works for the HTML and PDF output.
In addtion, one can control the width + height of the figure.
This is not the case for the common markdown syntax `[](<figure>)`.

Always store images also in a vector format (like .svg), even if you do not use them in vector format in the book. Otherwise, we cannot re-use or modify images in the future.

### Spacing

- Always start a new sentence on a new line, this keeps the diff readable.
- Put an empty line before and after code blocks.
