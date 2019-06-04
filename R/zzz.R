#' @import data.table
#' @import mlr3
#' @importFrom utils head hsearch_db
NULL

db = new.env()
db$index = c("base", "utils", "datasets", "data.table", "stats")
db$hosted = c("mlr3misc", "mlr3", "mlr3db", "mlr3survival", "mlr3ordinal", "paradox")

.onLoad = function(libname, pkgname) {
  db$base = NULL
  db$aliases = NULL
}
