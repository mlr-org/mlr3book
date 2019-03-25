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
  withr::with_dir(file.path(root, "inst", "bookdown"),
    bookdown::render_book(input = "index.Rmd")
  )
}
