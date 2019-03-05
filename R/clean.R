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
  withr::with_dir(path,
    bookdown::clean_book(clean)
  )
}
