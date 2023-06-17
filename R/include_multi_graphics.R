#' @export
include_multi_graphics = function(html_path, latex_path) {
  path = if (knitr::is_latex_output()) latex_path else html_path
  knitr::include_graphics(path)
}
