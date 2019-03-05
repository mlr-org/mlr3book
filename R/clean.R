#' @title Clean the mlr3 book
#'
#' @description
#' Calls [bookdown::clean_book()].
#'
#' @param clean Passed down to [bookdown::clean_book()].
#'
#' @export
clean_mlr3book = function(clean = FALSE) {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  wd = getwd()
  setwd(path)
  on.exit(setwd(wd))
  bookdown::clean_book(clean)
}
