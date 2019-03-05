serve_book = function() {
  path = system.file("bookdown", package = "mlr3book", mustWork = TRUE)
  bookdown::serve_book(path)
}
