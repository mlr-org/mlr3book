get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

if (Sys.getenv("HTML") == "true") {

  get_stage("deploy") %>%
    add_step(step_add_to_known_hosts("github.com")) %>%
    add_step(step_install_ssh_keys()) %>%
    add_step(step_setup_push_deploy(path = here::here("bookdown/_book"), branch = "gh-pages")) %>%
    add_step(step_run_code(withr::with_dir(
      "bookdown",
      bookdown::render_book("_output.yml", output_format = "bookdown::gitbook")
    ))) %>%
    add_step(step_run_code({
      files <- dir("bookdown/_book/", pattern = "[.]html$", full.names = TRUE)
      purrr::walk(files, ~ {
        print(system.time(pkgdown::autolink_html(.x)))
      })
    })) %>%
    add_step(step_do_push_deploy(path = here::here("bookdown/_book")))
} else if (Sys.getenv("PDF") == "true") {

  get_stage("deploy") %>%
    add_step(step_add_to_known_hosts("github.com")) %>%
    add_step(step_install_ssh_keys()) %>%
    add_step(step_setup_push_deploy(path = here::here("bookdown/_book"), branch = "gh-pages")) %>%
    add_step(step_run_code(withr::with_dir(
      "bookdown",
      bookdown::render_book("_output.yml", output_format = "bookdown::pdf_book")
    ))) %>%
    add_step(step_do_push_deploy(path = here::here("bookdown/_book"), commit_paths = here::here("bookdown/_book/mlr3book.pdf")))
}
