all: install serve

.PHONY : help
help :
	@echo "install : Install mlr3book and dependencies."
	@echo "serve   : Start a http server to serve the book."
	@echo "names   : Re-creates chunk names using mlr3book::name_chunks_mlr3book()."
	@echo "clean   : Remove auto-generated files."

install:
	Rscript -e 'if (length(find.package("devtools", quiet = TRUE)) == 0) install.packages("devtools")' ;\
	Rscript -e 'devtools::document()' ;\
	Rscript -e 'devtools::install(dependencies = TRUE, upgrade = "always")'

serve:
	Rscript -e 'bookdown::serve_book("bookdown")'

clean:
	$(RM) -r bookdown/_book bookdown/_bookdown_files bookdown/mlr3book_cache bookdown/mlr3book_files

html:
	cd bookdown ;\
	Rscript -e 'bookdown::render_book(input = "index.Rmd", "bookdown::gitbook", envir = new.env())'

pdf:
	cd bookdown ;\
	Rscript -e 'bookdown::render_book(input = "index.Rmd", "bookdown::pdf_book", envir = new.env())'

names:
	Rscript -e 'mlr3book::name_chunks_mlr3book()'
