#' Assign a cached version of a function in the nanespace
#'
#' Create a cached version of a function and overload the original function in the package namespace.
#' Currently this is used to ensure that the CI for the OpenML chapter does not fail when the server is down.
#'
#' @param fn_name (`character(1)`)/cr
#'   The name of the function to overload with a cached version.
#' @param package (`character(1)`)/cr
#'   The package in which the  function should be overloaded, e.g. `"mlr3oml"`.
#' @param cachedir (`character(1)`)/cr
#'   The cache directory relative to `.../mlr3book/book`.
#'
#' @export
assign_cached = function(fn_name, package, cachedir) {
  # Just a heuristic but should usually work

  fn = getFromNamespace(fn_name, ns = package)

  if (!endsWith(getwd(), "mlr3book/book")) {
    stop("Working directory must point to '.../mlr3book/book'.")
  }

  # Simulate the actual execution of the function from the stored console output and return object.
  simulate = function(response) {
    # This makes the output less readable.
    # mlr3misc::walk(response$console_output, function(line) mlr3misc::catn(line))
    invisible(response$object)
  }

  # This is the function that should produce an output that is just like the uncached version
  fn_cached = function(...) {
    # Each function gets its own sub-directory in the cachedir
    path = file.path(cachedir, fn_name)
    if (!dir.exists(path)) {
      dir.create(path, recursive = TRUE)
    }

    filename = paste0(digest::sha1(list(fn_name, list(...))), ".rds")

    filepath = file.path(path, filename)

    if (!file.exists(filepath)) {
      # Cache does not exist
      console_output = capture.output(object <<- invisible(do.call(fn, args = list(...))))
      response = list(object = object, console_output = console_output)
      saveRDS(response, filepath)
    } else {
      # We load the cached object (console output and return object) from the cache.
      response = readRDS(filepath)
    }
    # In either case it should  look the same
    response
  }

  assignInNamespace(fn_name, fn_cached, ns = package)

  NULL
}
