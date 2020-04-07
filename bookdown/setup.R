library(mlr3)
library(mlr3book)

options(
  width = 80,
  digits = 4,
  knitr.graphics.auto_pdf = TRUE
)

if (knitr::is_latex_output()) {
  knitr::opts_chunk$set(fig.pos = "H")
} else if (knitr::is_html_output()) {
  # no special settings yet
}


knitr::opts_chunk$set(
  collapse = FALSE,
  cache = TRUE,
  cache.lazy = FALSE,
  fig.width = 6.5,
  fig.height = 4,
  fig.align = "center",
  results = "markup"
)

lgr::get_logger("mlr3")$set_threshold("warn")
