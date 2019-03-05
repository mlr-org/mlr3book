#' @title Serve the mlr3 book
#'
#' @description
#' Calls [bookdown::serve_book()].
#'
#' @export
serve_mlr3book = function() {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  bookdown::serve_book(path)
}
