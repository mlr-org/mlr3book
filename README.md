# mlr3book

[![mlr3book](https://github.com/mlr-org/mlr3book/workflows/mlr3book/badge.svg)](https://github.com/mlr-org/mlr3book/actions?query=workflow%3Amlr3book)
[![StackOverflow](https://img.shields.io/badge/stackoverflow-mlr3-orange.svg)](https://stackoverflow.com/questions/tagged/mlr3)
[![Mattermost](https://img.shields.io/badge/chat-mattermost-orange.svg)](https://lmmisld-lmu-stats-slds.srv.mwn.de/mlr_invite/)

Package to build the [mlr3 book](https://mlr3book.mlr-org.com) using [quarto](https://quarto.org).

## Rendered Versions

- [HTML](https://mlr3book.mlr-org.com)

- [PDF](https://mlr3book.mlr-org.com/Flexible-and-Robust-Machine-Learning-Using-mlr3-in-R.pdf)

## Working on the book

1. Clone the `mlr-org/mlr3book` repository.

1. Currently we need the latest quarto dev version to be able to render mermaid diagrams when rendering to pdf: https://quarto.org/docs/download/prerelease (we need >=1.3.283)

1. Call `make install` to initialize the renv virtual environment.
   The file `book/renv.lock` records all packages needed to build the book.

1. To build the book, run one of the following commands:

   ```bash
   # HTML
   quarto render book/ --to html

   # PDF
   quarto render book/ --to pdf
   ```

   These command use the virtual environment created by renv.

1. If your change to the book requires a new R package, install the package in the renv environment.
   For this, start an R session in the `book/` directory and install the package with `renv::install()`.
   Then call `renv::snapshot()` to update `book/renv.lock`.
   Commit `book/renv.lock` with your changes to a pull request.

## Serve the book

Alternatively, you "serve" the book via a local server:

```bash
quarto preview book/
```

The command above starts a service which automatically (re-)compiles the book sources in the background whenever a file is modified.

## Makefile approach

Alternatively, you can use the provided `Makefile` (c.f. see `make help`).
This way, you can

- install dependencies
- build the HTML book -> `make html`
- build the PDF book -> `make pdf`

## File system structure

The root directory is a regular R package.
The book itself is in the subdirectory "book".

## Style Guide

### Lists

For lists please use `*` and not `-`.

### Chunk Names

Chunks are named automatically as `[chapter-name]-#` by calling `name_chunks_mlr3book()`:

```r
mlr3book::name_chunks_mlr3book()
```

or alternatively executing `make names` from the terminal.

### Figures

You have to options to include a figure:

1) Vector graphic
  - In the `qmd`: `knitr::include_graphics("Figures/some_figure.svg")`
  - Add `book/Figures/some_figure.svg` **and** `book/Figures/some_figure.pdf` to the repository.
2) Pixel graphic
  - In the `qmd`: `knitr::include_graphics("Figures/some_figure.png")`
  - Add **only** `book/Figures/some_figure.png` to the repository.

* Do not use markdown syntax `[](<figure>)` to include figures.
* Do not include `pdf` in the `qmd`: `knitr::include_graphics("Figures/some_figure.pdf")`.

#### Adding a new figure

To add a new figure into the repository consider the following rules:

* Add the file in the `book/images` folder without any subdirectory.
* Store the original figure as a `svg` file if possible, i.e. if it is a vector graphic.
  This allows us to re-use or modify images in the future.
* `png` files should have reasonable resolution, i.e. the width of a pixel graphic should be between `400px` and `2000px`.
  If a higher resolution is needed to obtain a readable plot you are probably doing something wrong, e.g. use a pixel graphic where you should use a vector graphic.
* Please look at the file size.
  - If your `pdf` or `svg` file is larger than `1MB` it probably contains unnecessary hidden content or unvectorized parts.
  - If your `png` file is larger than `1MB` the resolution is probably too big.

#### Further aspects

* How do I convert `svg` to `pdf`?
  - Use Inkscape or any other tool which does not convert to raster images.
* How do I convert `pdf` to `svg`?
  - Use Inkscape which allows you to also remove unwanted parts of the `pdf`.
* Do not use screenshots!
  - *Google Slides* allows `svg` export.
  - *PDF* can be converted to `svg` and you can even cut parts.
  - *HTML* can be converted to `svg`.
* The difference between vector (`svg`) and pixel (`png`) graphics should be known.
  - Attention: `svg` and `pdf` also support to include pixel graphics.
    There is no guarantee that a `svg` or `pdf` is a pure vector graphic.
    If you paste a pixel graphic (e.g. a screenshot) into Inkscape and save it as `svg` it does not magically become a vector graphic.

### Spacing

- Always start a new sentence on a new line, this keeps the diff readable.
- Put an empty line before and after code blocks.
