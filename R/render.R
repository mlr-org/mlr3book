#' @title Render the mlr3 book
#'
#' @description
#' Calls [bookdown::render_book()].
#'
#' @param format (`character()`).
#'   Vector of output formats. Possible values: `"html"`, `"pdf"`.
#' @param ... Passed down to [bookdown::render_book()].
#'
#' @export
render_mlr3book = function(format = "html", ...) {
  root = rprojroot::find_package_root_file()
  source_dir = file.path(root, "bookdown")

  withr::with_dir(source_dir, {
    if ("html" %in% format) {
      bookdown::render_book(input = "index.Rmd", "bookdown::gitbook", envir = new.env(), ...)
    }

    if ("pdf" %in% format) {
      bookdown::render_book(input = "index.Rmd", "bookdown::pdf_book", envir = new.env(), ...)
    }
  })
}
