library(mlr3)
library(mlr3book)

options(
  width = 80,
  digits = 4,
  knitr.graphics.auto_pdf = TRUE
)

if (knitr::is_latex_output()) {
  options("width" = 56)
  knitr::opts_chunk$set(tidy.opts = list(width.cutoff = 56, indent = 2), tidy = TRUE)
  knitr::opts_chunk$set(fig.pos = "H")
} else if (knitr::is_html_output()) {
  knitr::opts_chunk$set(fig.width = 6.5,
    fig.height = 4,
    fig.align = "center",
    results = "markup")
}


knitr::opts_chunk$set(collapse = FALSE, cache = TRUE, cache.lazy = FALSE)
lgr::get_logger("mlr3")$set_threshold("warn")
