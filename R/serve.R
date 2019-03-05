serve_mlr3book = function() {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  serve_book(path)
}
