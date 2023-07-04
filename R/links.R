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
#' @param index If `TRUE` calls `index`
#' @param aside Passed to `index`
#'
#' @return (`character(1)`) markdown link.
#' @export
ref = function(topic, index = FALSE, aside = FALSE) {

  strip_parenthesis = function(x) sub("\\(\\)$", "", x)

  checkmate::assert_string(topic, pattern = "^[[:alnum:]._-]+(::[[:alnum:]._-]+)?(\\(\\))?$")

  topic = trimws(topic)

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

  out = sprintf("[`%s`](%s)", topic, url)

  if (index || aside) {
    out = paste0(out, index(main = NULL, index = topic, aside = aside, code = TRUE))
  }

  out
}

#' @title Hyperlink to Package
#'
#' @description
#' Links either to respective mlr3 website or to CRAN page.
#'
#' @param pkg Name of the package.
#' @param runiverse If `TRUE` (default) then creates R-universe link instead of GH
#' @param index If `TRUE` calls `index`
#' @param aside Passed to `index`
#'
#' @return (`character(1)`) markdown link.
#' @export
ref_pkg = function(pkg, runiverse = TRUE, index = FALSE, aside = FALSE) {
  checkmate::assert_string(pkg, pattern = "(^[[:alnum:]._-]+$)|(^[[:alnum:]_-]+/[[:alnum:]._-]+$)")

  pkg = trimws(pkg)

  if (grepl("/", pkg, fixed = TRUE)) {
    if (runiverse) {
      out = ru_pkg(pkg)
    } else {
      out = gh_pkg(pkg)
    }
  } else if (pkg %in% db$hosted) {
    out = mlr_pkg(pkg)
  } else {
    out = cran_pkg(pkg)
  }

  if (index || aside) {
    out = paste0(out, index(main = NULL, index = pkg, aside = aside))
  }

  out
}

cran_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  pkg = trimws(pkg)

  if (pkg %in% c("stats", "graphics", "datasets")) {
    sprintf("`%s`", pkg)
  } else {
    url = sprintf("https://cran.r-project.org/package=%s", pkg)
    sprintf("[`%s`](%s)", pkg, url)
  }
}

mlr_pkg = function(pkg, index = FALSE, aside = FALSE) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]._-]+$")
  pkg = trimws(pkg)

  url = sprintf("https://%1$s.mlr-org.com", pkg)
  out = sprintf("[`%s`](%s)", pkg, url)

  if (index || aside) {
    out = paste0(out, index(main = NULL, index = pkg, aside = aside,
      code = TRUE, lower = FALSE))
  }

  out
}

gh_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")
  pkg = trimws(pkg)

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://github.com/%s", pkg)
  sprintf("[`%s`](%s)", parts[2L], url)
}

ru_pkg = function(pkg) {
  checkmate::assert_string(pkg, pattern = "^[[:alnum:]_-]+/[[:alnum:]._-]+$")

  parts = strsplit(pkg, "/", fixed = TRUE)[[1L]]
  url = sprintf("https://%s.r-universe.dev/ui#package:%s", parts[1L], parts[2L])
  sprintf("[`%s`](%s)", parts[2L], url)
}

toproper = function(str) {
  str = strsplit(str, " ", TRUE)[[1]]
  paste0(toupper(substr(str, 1, 1)), tolower(substr(str, 2, 100)), collapse = " ")
}

#' @title Add term to index if non-NULL
#' @param main Text to show in book
#' @param index Index entry if different from `main
#' @param aside If TRUE prints in margin
#' @param code If TRUE tells function to wrap in ``
#' @param lower If TRUE makes non-code index entry lower case (required by publisher)
#' @param see If non-NULL index entry to 'see'
#' @param parent If non-NULL index parent entry
#' @export
index = function(main = NULL, index = NULL, aside = FALSE, code = FALSE, lower = TRUE, see = NULL,
  parent = NULL) {

  stopifnot(!(is.null(main) && is.null(index)))
  asidetext = NULL
  if (is.null(main)) {
    out = ""
    if (aside) {
      if (code) {
        asidetext = sprintf("`%s`", index)
      } else {
        asidetext = toproper(index)
      }
    }
  } else if (code) {
    out = sprintf("`%s`", main)
  } else {
    out = main
  }

  if (code) lower = FALSE

  if (is.null(index)) index = ifelse(lower, tolower(main), main)

  index = gsub("([\\$\\_])", "\\\\\\1", index)

  if (code) index = sprintf("\\texttt{%s}", index)

  if (!is.null(parent) && !is.null(see)) stop("not worth the effort, do it manually")

  if (!is.null(parent)) {
    if (code) {
      parent = sprintf("\\texttt{%s}", parent)
    } else if (lower) {
      parent = tolower(parent)
    }
    index = sprintf("%s!%s", parent, index)
  }

  if (!is.null(see)) {
    if (code) {
      see = sprintf("\\texttt{%s}", see)
    } else if (lower) {
      see = tolower(see)
    }
    index = sprintf("%s|see{%s}", index, see)
  }

  out = sprintf("%s\\index{%s}", out, index)

  if (aside) {
    if (is.null(asidetext)) {
      asidetext = if (code || !lower) main else toproper(main)
    }
    out = sprintf("%s[%s]{.aside}", out, asidetext)
  }

  out
}

#' @title Define - tmp will be removed
#' @param text text to define
#' @export
define = function(text) {
  index(text, aside = TRUE)
}

#' @title Create markdown and print-friendly link
#'
#' @description
#' Creates markdown link and footnote with full link
#'
#' @param url URL to link to
#'
#' @export
link = function(url) {
  sprintf("[%s](%s)", url, url)
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
