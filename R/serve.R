#' @title Serve the mlr3 book
#'
#' @description
#' Calls [bookdown::serve_book()].
#'
#' @export
serve_mlr3book = function() {
  root = rprojroot::find_package_root_file()
  bookdown::serve_book(file.path(root, "bookdown"))
}
