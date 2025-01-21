# mlr3book

[![mlr3book](https://github.com/mlr-org/mlr3book/actions/workflows/book-weekly.yml/badge.svg)](https://github.com/mlr-org/mlr3book/actions/workflows/book-weekly.yml)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)
[![Mattermost](https://img.shields.io/badge/chat-mattermost-orange.svg)](https://lmmisld-lmu-stats-slds.srv.mwn.de/mlr_invite/)

Repository to build the free, online version of *[Applied Machine Learning Using mlr3 in R](https://mlr3book.mlr-org.com)* using [quarto](https://quarto.org).
You can buy a print copy of the book [here](https://www.routledge.com/Applied-Machine-Learning-Using-mlr3-in-R/Bischl-Sonabend-Kotthoff-Lang/p/book/9781032507545) - all profits from the book will go to the mlr organisation to support future maintenance and development of the mlr universe.


## Read the book

You can read the rendered version of the book in either:

- [HTML](https://mlr3book.mlr-org.com); or

- [PDF](https://mlr3book.mlr-org.com/Applied-Machine-Learning-Using-mlr3-in-R.pdf).

## Render the book

To render the book yourself, follow these steps:

1. Clone this repository (https://github.com/mlr-org/mlr3book.git)
2. Install Quarto >=1.3.283 if needed
3. Run `make serve` to render the book to HTML and preview on a local server or `make pdf` to render to PDF (other options are available and documented in the Makefile), note we use xelatex for rendering to PDF

## Contributing to the book

If you are making changes to the book please note the following:

* Our style guide is provided [here in the introduction](https://mlr3book.mlr-org.com/chapters/chapter1/introduction_and_overview.html#styleguide)
* Where possible, figures in the HTML book should be svgs and figures in the PDF should be pdf. These should be included with `knitr::include_graphics()` or ideally with [include_multi_graphics()](https://github.com/mlr-org/mlr3book/blob/main/book/common/_utils.qmd).

When (non-trivial) changes and corrections are made to chapters that are are included in the first published edition of this book, these changes should be documented in the *Errata* appendix.
When adding new chapters to the book not present in the published version, these should be marked as *Online Only* in their title.
For such newly added chapters that are in early stages and have not been rigorously edited and reviewed, these should be additionally marked as being a *Draft*.

* If you add a new package dependency to the book, please follow the following steps to update the lockfile:
  * Start an R session in the `book/` directory
  * Activate the project with `renv::activate()`
  * Restore the project environment with `renv::restore()`
  * Run `renv::install()` to install the new package
  * Update the Lockfile with `renv::snapshot()`
  * Commit `book/renv.lock` with your changes and create a pull request.
