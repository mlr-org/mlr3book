#' @title Lists the mlr3verse pkg states of last successful mlr3book build
#'
list_mlr3verse_stable = function() {

  pkgs = mlr3misc::map_chr(mlr3verse::mlr3verse_packages(include_self = FALSE), function(.x) {

    sessioninfo::package_info(.x) %>%
      dplyr::filter(package == .x) %>%
      dplyr::select(source) %>%
      dplyr::pull() %>%
      strsplit(split="[()]") %>%
      unlist() %>%
      magrittr::extract(2)

  })

  pkgs = na.omit(pkgs)

  print(sprintf("remotes::install_github(c(%s), force = TRUE)", mlr3misc::str_collapse(pkgs, quote = "'")), quote = FALSE)

}
