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
  withr::with_dir(path,
    bookdown::render_book(input = "index.Rmd", ...)
  )
}
