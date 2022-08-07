#' @title Name all chunks
#'
#' @description
#' Names all chunks of all qmd files using the pattern `[file-name]-[number]`.
#'
#' @export
name_chunks_mlr3book = function() {
  root = rprojroot::find_package_root_file()
  path = file.path(root, "book")
  qmds = list.files(path, pattern = "^[^_].*\\.qmd$", full.names = TRUE, recursive = TRUE)
  pattern = "^([[:space:]]*```\\{[rR])([[:alnum:] -]*)(.*\\})[[:space:]]*$"

  for (qmd in qmds) {
    message(sprintf("Renaming chunks in '%s'", basename(qmd)))

    lines = readLines(qmd)
    ii = which(stringi::stri_detect_regex(lines, "^[[:space:]]*```\\{[rR].*\\}$"))
    labels = sprintf("%s-%03i", stringi::stri_replace_last_fixed(basename(qmd), ".qmd", ""), seq_along(ii))
    lines[ii] = stringi::stri_replace_first_regex(lines[ii], pattern, sprintf("$1 %s$3", labels))

    writeLines(stringi::stri_trim_right(lines), con = qmd)
  }

  invisible(TRUE)
}
