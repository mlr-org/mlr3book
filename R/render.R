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
  source_dir = file.path(root, "inst", "bookdown")
  output_dir = file.path(root, "docs")

  withr::with_dir(source_dir,
    bookdown::render_book(input = "index.Rmd", envir = new.env(), output_dir = output_dir)
  )
}
