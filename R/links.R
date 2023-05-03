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
ref = function(topic, text = NULL, format = "markdown") {
  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")
  checkmate::assert_string(text, min.chars = 1L, null.ok = TRUE)
  checkmate::assert_choice(format, c("markdown", "html"))

  topic = trimws(topic)
  text = if (is.null(text)) {
    topic
  } else {
    trimws(text)
  }

  if (stringi::stri_detect_fixed(topic, "::")) {
    parts = strsplit(topic, "::", fixed = TRUE)[[1L]]
    topic = parts[2L]
    name = strip_parenthesis(parts[2L])
    pkg = parts[1L]
  } else {
    update_db()
    matched = db$base[db$aliases[list(strip_parenthesis(topic)), c("Alias", "ID"), on = "Alias", nomatch = 0L], on = "ID", nomatch = NULL]

    # remove mlr3verse matches - these are just reexports with no helpful information on the man page
    matched = matched[get("Package") != "mlr3verse"]

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

  sprintf("[`%s`](%s){.refcode}", text, url)
}

#' @title Hyperlink to Package
#'
#' @description
#' Links either to respective mlr3 website or to CRAN page.
#'
#' @param pkg Name of the package.
#' @param runiverse If `TRUE` (default) then creates R-universe link instead of GH
#' @inheritParams ref
#'
#' @return (`character(1)`) markdown link.
#' @export
ref_pkg = function(pkg, runiverse = TRUE, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "(^[[:alnum:]._-]+$)|(^[[:alnum:]_-]+/[[:alnum:]._-]+$)")
  checkmate::assert_choice(format, c("markdown", "html"))
  pkg = trimws(pkg)

  if (grepl("/", pkg, fixed = TRUE)) {
    if (runiverse) {
      out = ru_pkg(pkg, format = format)
    } else {
      out = gh_pkg(pkg, format = format)
    }
  } else if (pkg %in% db$hosted) {
    out = mlr_pkg(pkg, format = format)
  } else {
    out = cran_pkg(pkg, format = format)
  }

  sprintf("[%s]{.refpkg}", out)
}

cran_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))
  pkg = trimws(pkg)

  if (pkg %in% c("stats", "graphics", "datasets")) {
    sprintf("`%s`", pkg)
  } else {
    url = sprintf("https://cran.r-project.org/package=%s", pkg)
    switch(format,
      "markdown" = sprintf("[`%s`](%s)", pkg, url),
      "html" = sprintf("<a href = \"%s\">%s</a>", url, pkg)
    )
  }
}

mlr_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))
  pkg = trimws(pkg)

  url = sprintf("https://%1$s.mlr-org.com", pkg)
  switch(format,
    "markdown" = sprintf("[`%s`](%s)", pkg, url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, pkg)
  )
}

gh_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))
  pkg = trimws(pkg)

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://github.com/%s", pkg)
  switch(format,
    "markdown" = sprintf("[`%s`](%s)", parts[2L], url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, parts[2L])
  )
}

ru_pkg = function(pkg, format = "markdown") {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  checkmate::assert_choice(format, c("markdown", "html"))

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://%s.r-universe.dev/ui#package:%s", parts[1L], parts[2L])
  switch(format,
    "markdown" = sprintf("[`%s`](%s)", parts[2L], url),
    "html" = sprintf("<a href = \"%s\">%s</a>", url, parts[2L])
  )
}

toproper = function(str) {
  str = strsplit(str, " ", TRUE)[[1]]
  paste0(toupper(substr(str, 1, 1)), tolower(substr(str, 2, 100)), collapse = " ")
}

#' @title Add term to index and margin
#' @param main Text to show in book
#' @param index Text to show in index
#' @param margin Text to show in margin
#' @export
define = function(main, margin = toproper(main), index = toproper(main)) {
  sprintf("\\index{%s}%s[%s]{.aside}", index, main, margin)
}

#' @title Add term to index
#' @param main Text to show in book
#' @param index Index entry if different from `main
#' @export
index = function(main, index = toproper(main)) {
  sprintf("\\index{%s}%s", index, main)
}

#' @title Create markdown and print-friendly link
#'
#' @description
#' Creates markdown link and footnote with full link
#'
#' @param url URL to link to
#' @param text Text to display in main text
#'
#' @export
link = function(url, text = NULL) {
  if (is.null(text)) {
    sprintf("[%s](%s)", url, url)
  } else {
    sprintf("[%s](%s)^[[%s](%s)]", text, url, url, url)
  }
}

#' @name paradox
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3misc
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3data
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3db
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3proba
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3pipelines
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3learners
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3filters
#' @title Helper mlr links
#' @export
NULL

#' @name bbotk
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3tuning
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3fselect
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3cluster
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3spatiotempcv
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3spatial
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3extralearners
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3tuningspaces
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3hyperband
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3mbo
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3viz
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3verse
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3benchmark
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3oml
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3batchmark
#' @title Helper mlr links
#' @export
NULL

#' @name mlr3fairness
#' @title Helper mlr links
#' @export
NULL