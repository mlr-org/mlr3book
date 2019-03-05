update_db = function() {
  if (is.null(db$base) || is.null(db$aliases)) {
    hdb = hsearch_db(package = c(db$index, db$hosted), types = "help")
    db$base = setkeyv(as.data.table(hdb$Base), "ID")
    db$aliases = setkeyv(as.data.table(hdb$Aliases), "Alias")
  }
}

#' @title Hyperlink to Function Reference
#'
#' @description
#' Creates a markdown link to a function reference.
#'
#' @param topic Name of the topic to link against.
#'
#' @return (`character(1)`) markdown link.
#' @export
ref = function(topic) {
  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")

  topic = trimws(topic)
  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  if (grepl("::", topic, fixed = TRUE)) {
    parts = strsplit(topic, "::", fixed = TRUE)[[1L]]
    topic = parts[2L]
    name = strip_parenthesis(parts[2L])
    pkg = parts[1L]
  } else {
    update_db()
    matched = head(db$base[db$aliases[list(strip_parenthesis(topic)), on = "Alias", nomatch = 0L], on = "ID", nomatch = 0L], 1L)
    if (nrow(matched) == 0L)
      stop(sprintf("Could not find help page for topic '%s'", topic))

    name = matched$Name
    pkg = matched$Package
  }


  if (pkg %in% db$hosted) {
    sprintf("[`%s`](https://%s.mlr-org.com/reference/%s.html)", topic, pkg, name)
  } else {
    sprintf("[`%s`](https://www.rdocumentation.org/packages/%s/topics/%s)", topic, pkg, name)
  }
}

#' @title Hyperlink to CRAN Package
#'
#' @description
#' Creates a markdown link to a CRAN package.
#'
#' @param pkg Name of the CRAN package.
#'
#' @return (`character(1)`) markdown link.
#' @export
cran_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  sprintf("[%1$s](https://cran.r-project.org/package=%1$s)", trimws(pkg))
}

#' @title Hyperlink to mlr3 Package
#'
#' @description
#' Creates a markdown link to a mlr3 package with a "mlr-org.com" subdomain.
#'
#' @param pkg Name of the mlr3 package.
#'
#' @return (`character(1)`) markdown link.
#' @export
mlr_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  sprintf("[%1$s](https://%1$s.mlr-org.com)", trimws(pkg))
}

#' @title Hyperlink to GitHub Repository
#'
#' @description
#' Creates a markdown link to GitHub repository.
#'
#' @param pkg Name of the repository specified as "{repo}/{name}".
#'
#' @return (`character(1)`) markdown link.
#' @export
gh_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  sprintf("[`%s`](https://github.com/%s)", parts[2L], pkg)
}
