# mlr3book

[![Travis build status](https://travis-ci.org/mlr-org/mlr3book.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3book)

Package to build the mlr3 [bookdown](https://bookdown.org/) book.

To build the book, run the following command in the repository root:
```{r}
pkgload::load_all()
serve_mlr3book()
```
This starts a service which automatically (re-)compiles the bookdown sources in the background.
