get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

if (Sys.getenv("HTML") == "true") {
  get_stage("script") %>%
    add_step(step_run_code(withr::with_dir(
      "bookdown",
      bookdown::render_book("_output.yml", output_format = "bookdown::gitbook")
    ))) %>%
    add_step(step_run_code(unlink(dir("docs", pattern = "^[^0-9]",
      full.names = TRUE), recursive = TRUE))) %>%
    add_step(step_run_code(file.copy(dir("book/_book", full.names = TRUE),
      "docs", recursive = TRUE))) %>%
    add_step(step_run_code({
      files <- dir("docs", pattern = "[.]html$", full.names = TRUE)
      purrr::walk(files, ~ {
        print(system.time(pkgdown::autolink_html(.x)))
      })
    }))
} else if (Sys.getenv("PDF") == "true") {

  get_stage("script") %>%
    add_code_step(remove.packages("tinytex")) %>%
    add_step(step_run_code(withr::with_dir(
      "bookdown",
      bookdown::render_book("_output.yml", output_format = "bookdown::pdf_book")
    ))) %>%
    add_step(step_run_code(unlink(dir("docs", pattern = "^[^0-9]",
      full.names = TRUE), recursive = TRUE))) %>%
    add_step(step_run_code(file.copy(dir("book/_book/mlr3book.pdf",
      full.names = TRUE), "docs")))
}

get_stage("deploy") %>%
  add_step(step_add_to_known_hosts("github.com")) %>%
  add_step(step_install_ssh_keys()) %>%
  add_step(step_setup_push_deploy(path = "docs", branch = "gh-pages")) %>%
  add_step(step_do_push_deploy(path = "docs"))
