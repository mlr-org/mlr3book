#' @title Clean the mlr3 book
#'
#' @description
#' Calls [bookdown::clean_book()] with `clean` set to `TRUE`.
#'
#' @export
clean_mlr3book = function() {
  root = rprojroot::find_package_root_file()
  withr::with_dir(file.path(root, "bookdown"),
    bookdown::clean_book(clean = TRUE)
  )
}
