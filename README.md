# mlr3book

[![Travis build status](https://travis-ci.org/mlr-org/mlr3book.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3book)

Package to build the mlr3 [bookdown](https://bookdown.org/) book.
The rendered book can be found [here](https://mlr-org.github.io/mlr3book/).

To install all necessary dependencies for the book, install the this package using [remotes](https://cran.r-project.org/package=remotes):
```r
remotes::install_github("mlr-org/mlr3book", dependencies = TRUE)
```

To build the book, run the following command in the repository root:
```r
pkgload::load_all()
serve_mlr3book()
```
This starts a service which automatically (re-)compiles the bookdown sources in the background.


## Style Guide

### Chunk Names
* Chunks should be named `[chapter-name]-id`, where id is some short description of what is happening.

### Links and References
* The package `mlr3book` provides the helpers `cran_pkg()`, `mlr_pkg()`, `gh_pkg()`, and `ref()`

### Blocks 
* Blocks for notes, warnings, ... TODO
