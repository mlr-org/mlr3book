#' @import data.table
#' @import mlr3
#' @importFrom utils head hsearch_db
NULL

db = new.env()
db$index = c("base", "utils", "datasets", "data.table", "stats", "batchtools")
db$hosted = c("paradox", "mlr3misc", "mlr3", "mlr3data", "mlr3db", "mlr3proba", "mlr3pipelines", "mlr3learners", "mlr3filters", "bbotk", "mlr3tuning", "mlr3viz", "mlr3fselect", "mlr3cluster", "mlr3spatiotempcv", "mlr3spatial", "mlr3extralearners", "mlr3tuningspaces", "mlr3hyperband", "mlr3mbo", "mlr3verse", "mlr3benchmark", "mlr3oml", "mlr3batchmark", "mlr3fairness")

lgr = NULL

.onLoad = function(libname, pkgname) {
  db$base = NULL
  db$aliases = NULL

  lgr <<- lgr::get_logger("mlr3book")
  # root = rprojroot::find_package_root_file()
  # logfile = file.path(root, "mlr3book.log")
  # lgr$set_appenders(lgr::AppenderFile$new(logfile))
}

update_db()
for (pkg in db$hosted) {
  assign(pkg, mlr_pkg(pkg, index = TRUE))
}
