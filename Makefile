all: install serve

.PHONY : help
help :
	@echo "install : Install mlr3book and dependencies."
	@echo "serve   : Start a http server to serve the book."
	@echo "pdf     : Render book as pdf."
	@echo "html    : Render book as html."
	@echo "names   : Re-creates chunk names using mlr3book::name_chunks_mlr3book()."
	@echo "clean   : Remove auto-generated files."
	@echo "bibtex  : Reformats the bibtex file."

install:
	Rscript -e 'if (length(find.package("devtools", quiet = TRUE)) == 0) install.packages("devtools")' \
	        -e 'devtools::install_dev_deps(upgrade = "always")' \
			-e 'devtools::update_packages(upgrade = "always")' \
	        -e 'devtools::document()' \
			-e 'devtools::install()'

serve:
	Rscript -e 'bookdown::serve_book("bookdown")'

clean:
	$(RM) -r bookdown/_book bookdown/_bookdown_files bookdown/mlr3book_files;\
	find -regex '^./bookdown.*cache$$' -exec rm -rf {} +;\
	find -regex '^./bookdown.*files$$' -exec rm -rf {} +;

html:
	Rscript -e 'mlr3book::render_mlr3book("html")'

pdf:
	Rscript -e 'mlr3book::render_mlr3book("pdf")'

names:
	Rscript -e 'mlr3book::name_chunks_mlr3book()'

bibtex:
	biber --tool --output-align --output-indent=2 --output-fieldcase=lower bookdown/book.bib -O bookdown/book.bib
	rm bookdown/book.bib.blg

