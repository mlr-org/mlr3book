get_stage("install") %>%
    add_step(step_run_code(remotes::install_deps()))

get_stage("script") %>%
    add_step(step_run_code(withr::with_dir(
        "bookdown",
        bookdown::render_book("_output.yml", output_format = "all")
    ))) %>%
    add_step(step_run_code({
        files <- dir("docs", pattern = "[.]html$", full.names = TRUE)
        walk(files, ~ {
            print(system.time(pkgdown::autolink_html(.x)))
        })
    }))