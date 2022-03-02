update_db = function() {
  if (is.null(db$base) || is.null(db$aliases)) {
    hdb = hsearch_db(package = unique(c(db$index, db$hosted)), types = "help")
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
#' @param text Text to use for the link. Defaults to the topic name.
#' @param format Either markdown or HTML.
#'
#' @return (`character(1)`) markdown link.
#' @export
ref = function(topic, text = topic, format = "markdown") {
  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")
  checkmate::assert_string(text, min.chars = 1L)
  checkmate::assert_choice(format, c("markdown", "html"))

  topic = trimws(topic)
  text = trimws(text)

  if (stringi::stri_detect_fixed(topic, "::")) {
    parts = strsplit(topic, "::", fixed = TRUE)[[1L]]
    topic = parts[2L]
    name = strip_parenthesis(parts[2L])
    pkg = parts[1L]
  } else {
    update_db()
    matched = db$base[db$aliases[list(strip_parenthesis(topic)), c("Alias", "ID"), on = "Alias", nomatch = 0L], on = "ID", nomatch = NULL]
    if (nrow(matched) == 0L) {
      stop(sprintf("Could not find help page for topic '%s'", topic))
    }
    if (nrow(matched) >= 2L) {
      lgr$warn("Ambiguous link to '%s': %s", topic, paste0(paste(matched$Package, matched$Name, sep = "::"), collapse = " | "))
      matched = head(matched, 1L)
    }

    pkg = matched$Package
    name = matched$Name
    lgr$debug("Resolved '%s' to '%s::%s'", topic, pkg, name)
  }

  if (pkg %in% db$hosted) {
    url = sprintf("https://%s.mlr-org.com/reference/%s.html", pkg, name)
  } else {
    url = sprintf("https://www.rdocumentation.org/packages/%s/topics/%s", pkg, name)
  }

  switch(format,
    "markdown" = sprintf("[`%s`](%s)", text, url),
    "html" = sprintf("<a href=\"%s\">%s</a>", url, text)
  )
}

#' @title Hyperlink to Package
#'
#' @description
#' Links either to respective mlr3 website or to CRAN page.
#'
#' @param pkg Name of the package.
#'
#' @return (`character(1)`) markdown link.
#' @export
ref_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))

  if (trimws(pkg) %in% db$hosted) {
    mlr_pkg(pkg, format = format)
  } else {
    cran_pkg(pkg, format = format)
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
cran_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))

  if (pkg %in% c("stats", "graphics", "datasets")) {
    trimws(pkg)
  } else {
    sprintf("[%1$s](https://cran.r-project.org/package=%1$s)", trimws(pkg))
  }
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
mlr_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))

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
gh_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  parts = strsplit(trimws(pkg), "/", fixed = TRUE)[[1L]]
  sprintf("[%s](https://github.com/%s)", parts[2L], pkg)
}
