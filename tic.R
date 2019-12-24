# install dependencies ---------------------------------------------------------

get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

# init deployment --------------------------------------------------------------

get_stage("deploy") %>%
  add_step(step_add_to_known_hosts("github.com")) %>%
  add_step(step_install_ssh_keys()) %>%
  add_step(step_setup_push_deploy(path = here::here("bookdown/_book"),
    branch = "gh-pages")) %>%

  # render gitbook -------------------------------------------------------------

  add_step(step_run_code(withr::with_dir(
    "bookdown",
    bookdown::render_book("_output.yml", output_format = "bookdown::gitbook")
  ))) %>%

  # render pinp ----------------------------------------------------------------

  add_step(step_run_code(withr::with_dir(
    "bookdown",
    bookdown::render_book("_output.yml", output_format = "pinp::pinp")
  ))) %>%
  add_code_step(file.rename(here::here("bookdown/_book/mlr3book.pdf"),
    here::here("bookdown/_book/mlr3book-pinp.pdf"))) %>%

  # render pdf -----------------------------------------------------------------

  add_step(step_run_code(withr::with_dir(
    "bookdown",
    bookdown::render_book("_output.yml", output_format = "bookdown::pdf_book")
  ))) %>%

  # use pkgdown autolinker for HTML hyperlinks ---------------------------------

  add_step(step_run_code({
    files <- dir("bookdown/_book/", pattern = "[.]html$", full.names = TRUE)
    purrr::walk(files, ~ {
      print(system.time(pkgdown::autolink_html(.x)))
    })
  })) %>%

  # deploy ---------------------------------------------------------------------

  add_step(step_do_push_deploy(path = here::here("bookdown/_book")))
