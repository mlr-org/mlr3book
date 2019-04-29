# mlr3book

[![Travis build status](https://travis-ci.org/mlr-org/mlr3book.svg?branch=master)](https://travis-ci.org/mlr-org/mlr3book)

Package to build the mlr3 [bookdown](https://bookdown.org/) book.

To install all necessary dependencies for the book, install the `r gh_pkg("mlr-org/mlr3book")` package using `r cran_pkg("remotes")`:
```{r index-1, eval=FALSE}
remotes::install_github("mlr-org/mlr3book", dependencies = TRUE)
```

To build the book, run the following command in the repository root:
```{r}
pkgload::load_all()
serve_mlr3book()
```
This starts a service which automatically (re-)compiles the bookdown sources in the background.
