render_mlr3book = function(...) {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  wd = getwd()
  setwd(path)
  on.exit(setwd(wd))
  bookdown::render_book(input = "index.Rmd", ...)
}
