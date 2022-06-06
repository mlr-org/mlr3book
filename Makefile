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
	quarto preview book/

clean:
	$(RM) -r book/_book book/.quarto book/site_libs;\
	rm book/*.ps$';\
	rm book/*.dvis$';\

html:
	quarto render book/index.qmd --to html

pdf:
	quarto render book/index.qmd --to pdf

names:
	Rscript -e 'mlr3book::name_chunks_mlr3book()'

bibtex:
	biber --tool --output-align --output-indent=2 --output-fieldcase=lower book/book.bib -O book/book.bib
	rm book/book.bib.blg

