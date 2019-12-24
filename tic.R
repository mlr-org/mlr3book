# install dependencies ---------------------------------------------------------

get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

# init deployment --------------------------------------------------------------

if (ci_get_branch() == "pdf") {
  get_stage("deploy") %>%
    add_step(step_add_to_known_hosts("github.com")) %>%
    add_step(step_install_ssh_keys()) %>%
    add_step(step_setup_push_deploy(path = "bookdown/_book",
      branch = "gh-pages", orphan = TRUE))
}

# render gitbook -------------------------------------------------------------

get_stage("deploy") %>%
  add_step(step_run_code(withr::with_dir(
    "bookdown",
    bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook",
      envir = new.env())
  ))) %>%

  # use pkgdown autolinker for HTML hyperlinks ---------------------------------

  add_code_step({
    files <- dir("bookdown/_book/", pattern = "[.]html$", full.names = TRUE)
    purrr::walk(files, ~ {
      print(system.time(pkgdown::autolink_html(.x)))
    })
  }) %>%

  # render pinp ----------------------------------------------------------------

  add_code_step(withr::with_dir(
    "bookdown",
    bookdown::render_book("index.Rmd", output_format = "pinp::pinp",
    )
  )) %>%
  add_code_step(file.rename(here::here("bookdown/mlr3book.pdf"),
    here::here("bookdown/_book/mlr3book-pinp.pdf"))) %>%

  # render pdf -----------------------------------------------------------------

  add_code_step(withr::with_dir(
    "bookdown",
    bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book",
    )
  )) %>%
  add_code_step(file.rename(here::here("bookdown/mlr3book.pdf"),
    here::here("bookdown/_book/mlr3book.pdf")))

# deploy ---------------------------------------------------------------------

if (ci_get_branch() == "pdf") {
  get_stage("deploy") %>%
    # write CNAME
    add_code_step(writeLines("mlr3book.mlr-org.com", "bookdown/_book/CNAME")) %>%
    # deploy
    add_step(step_do_push_deploy(path = "bookdown/_book"))
}
