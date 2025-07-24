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

1. Clone this repository (https://github.com/mlr-org/mlr3book.git) and navigate to the `mlr3book` directory.
2. Pull the docker image `docker pull mlrorgdocker/mlr3-book`.
3. Preview the book with

```bash
docker run --name mlr3book \
 -v $(pwd):/book \
 --rm \
 -p 8888:8888 \
 mlrorg/mlr3-book quarto preview book/book --port 8888 --host 0.0.0.0 --no-browser
```

This command mounts your current directory into the docker container, allowing quarto to render the book and serve it on port 8888.
Access the preview at `http://0.0.0.0:8888`.

Make your changes locally and preview them with the above command.
Once you are happy with your changes, open a pull request.
The pull request will include a preview of your changes

If your changes require new packages, install them in the docker image using the `remotes` package.

```r
remotes::install_github("mlr-org/mlr3extralearners")
remotes::install_cran("qgam")
```

You can add these command temporary at the beginning of the new chapter.
Once the pull request is accepted, add the new packages to the mlr3-book dockerfile at [https://github.com/mlr-org/mlr3docker](mlr-org/mlr3docker) and remove the installation with `remotes`.

## Contributing to the book

If you are making changes to the book please note the following:

* Our style guide is provided [here in the introduction](https://mlr3book.mlr-org.com/chapters/chapter1/introduction_and_overview.html#styleguide)
* Where possible, figures in the HTML book should be svgs and figures in the PDF should be pdf. These should be included with `knitr::include_graphics()` or ideally with [include_multi_graphics()](https://github.com/mlr-org/mlr3book/blob/main/book/common/_utils.qmd).

When (non-trivial) changes and corrections are made to chapters that are are included in the first published edition of this book, these changes should be documented in the *Errata* appendix.
When adding new chapters to the book not present in the published version, these should be marked as *Online Only* in their title.
For such newly added chapters that are in early stages and have not been rigorously edited and reviewed, these should be additionally marked as being a *Draft*.

