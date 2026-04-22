#' @import data.table
#' @importFrom utils head hsearch_db
NULL

# ref() resolves function names to links pointing to our online documentation.
# Only installed packages are included in the help database.
# A startup message lists any missing packages.
db = new.env()
db$index = c("base", "utils", "datasets", "data.table", "stats")
db$hosted = c(
  "batchtools",
  "bbotk",
  "mlr3",
  "mlr3batchmark",
  "mlr3benchmark",
  "mlr3cluster",
  "mlr3data",
  "mlr3db",
  "mlr3extralearners",
  "mlr3fairness",
  "mlr3filters",
  "mlr3fselect",
  "mlr3hyperband",
  "mlr3inferr",
  "mlr3learners",
  "mlr3mbo",
  "mlr3misc",
  "mlr3oml",
  "mlr3pipelines",
  "mlr3proba",
  "mlr3spatial",
  "mlr3spatiotempcv",
  "mlr3tuning",
  "mlr3tuningspaces",
  "mlr3verse",
  "mlr3viz",
  "paradox"
)

lgr = NULL

.onLoad = function(libname, pkgname) {
  db$base = NULL
  db$aliases = NULL

  lgr <<- lgr::get_logger("mlr3book")

  check_pkgs = setdiff(unique(c(db$index, db$hosted)), c("base", "utils", "datasets", "stats"))
  missing = check_pkgs[!vapply(check_pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing)) {
    packageStartupMessage(sprintf(
      "The following packages are not available: %s. Some references may not work.",
      paste(missing, collapse = ", ")
    ))
  }
}

update_db()
for (pkg in db$hosted) {
  assign(pkg, mlr_pkg(pkg, index = TRUE))
}
