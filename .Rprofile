testthat::set_max_fails(1)
Sys.setenv(RUSH_TEST_USE_REDIS = "true")

# Hotfix languageserver: ignore virtual URIs for diagnostics
ns = asNamespace("languageserver")
orig = get("diagnose_file", envir = ns)
my_diagnose_file = function(uri, content, is_rmarkdown = FALSE, globals = NULL, cache = FALSE) {
  if (grepl("^(git:|vscode-|gitlens:|scm:)", uri)) {
    return(list())
  }
  # Ensure `.lintr` is respected for unsaved buffers / inline linting.
  #
  # languageserver lints editor buffers via `lintr::lint(path, text = content)`.
  # lintr treats this as "inline data" and (by default) skips parsing settings,
  # which leads to default linters being used and false positives (e.g. `=`).
  if (length(content) == 0) {
    return(list())
  }
  if (is_rmarkdown) {
    if (!any(stringi::stri_detect_regex(content, "```\\{r[ ,\\}]"))) {
      return(list())
    }
  }
  path = languageserver:::path_from_uri(uri)
  if (length(content) == 1) {
    content = c(content, "")
  }
  if (length(globals)) {
    env_name = "languageserver:globals"
    do.call("attach", list(globals, name = env_name, warn.conflicts = FALSE))
    on.exit(do.call("detach", list(env_name, character.only = TRUE)))
  }
  lints = lintr::lint(path, cache = cache, text = content, parse_settings = TRUE)
  diagnostics = lapply(lints, languageserver:::diagnostic_from_lint, content = content)
  names(diagnostics) = NULL
  diagnostics
}
unlockBinding("diagnose_file", ns)
assign("diagnose_file", my_diagnose_file, envir = ns)
lockBinding("diagnose_file", ns)