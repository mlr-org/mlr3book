#' @import data.table
#' @import mlr3
#' @importFrom utils head hsearch_db
NULL

db = new.env()
db$index = c("base", "utils", "datasets", "data.table", "stats")
db$hosted = c("paradox", "mlr3misc", "mlr3", "mlr3db", "mlr3survival", "mlr3ordinal", "mlr3pipelines", "mlr3learners", "mlr3featsel", "mlr3tuning", "mlr3viz")

.onLoad = function(libname, pkgname) {
  db$base = NULL
  db$aliases = NULL
}
