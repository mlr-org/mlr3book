#' @import data.table
NULL

db = new.env()
db$index = c("base", "utils", "datasets", "data.table")
db$hosted = c("mlr3", "mlr3db", "mlr3survival", "mlr3ordinal")

.onLoad = function(libname, pkgname) {
    hdb = utils::hsearch_db(package = c(db$index, db$hosted), types = "help")
    db$base = setkeyv(as.data.table(hdb$Base), "ID")
    db$aliases = setkeyv(as.data.table(hdb$Aliases), "Alias")
}
