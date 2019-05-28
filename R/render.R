#' @title Render the mlr3 book
#'
#' @description
#' Calls [bookdown::render_book()].
#'
#' @param ... Passed down to [bookdown::render_book()].
#'
#' @export
render_mlr3book = function(...) {
  root = rprojroot::find_package_root_file()
  source_dir = file.path(root, "bookdown")

  withr::with_dir(source_dir, {
    bookdown::render_book(input = "index.Rmd", "bookdown::gitbook", envir = new.env())
    # bookdown::render_book(input = "index.Rmd", "bookdown::pdf_book", envir = new.env())
  })
}
