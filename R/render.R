#' @title Render the mlr3 book
#'
#' @description
#' Calls [bookdown::render_book()].
#'
#' @param ... Passed down to [bookdown::render_book()].
#'
#' @export
render_mlr3book = function(...) {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  wd = getwd()
  setwd(path)
  on.exit(setwd(wd))
  bookdown::render_book(input = "index.Rmd", ...)
}
