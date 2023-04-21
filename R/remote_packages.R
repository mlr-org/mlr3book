#' @title List Remote Packages
#'
#' @description
#' List remote packages in `renv.lock` file.
#'
#' @export
remote_packages = function(lock_file = "book/renv.lock") {
  packages = jsonlite::read_json(lock_file)[["Packages"]]
  packages = mlr3misc::discard(packages, function(x) !is.null(x$Repository) && x$Repository == "CRAN")
  names(packages)
}
