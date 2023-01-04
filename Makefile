all: install serve

.PHONY : help
help :
	@echo "install 				: Install renv and restore virtual environment."
	@echo "bookinstall 		: Install mlr3book without dependencies to virtual environment."
	@echo "serve   				: Start a http server to serve the book."
	@echo "serverefresh   : Clear cache and start a http server to serve the book."
	@echo "pdf     				: Render book as pdf."
	@echo "html    				: Render book as html."
	@echo "names   				: Re-creates chunk names using mlr3book::name_chunks_mlr3book()."
	@echo "clean   				: Remove auto-generated files."
	@echo "bibtex  				: Reformats the bibtex file."

install:
	Rscript --no-init-file -e 'install.packages("renv")' \
												 -e 'renv::activate("book/")' \
												 -e 'renv::restore("book/", prompt = FALSE)'

restore:
	Rscript --no-init-file -e 'renv::restore("./book/", prompt = FALSE)'

bookinstall:
	Rscript --no-init-file -e 'devtools::document()' \
												 -e 'renv::install(".", project = "./book/")'

serve:
	Rscript --no-init-file -e 'renv::restore("book/", prompt = FALSE)'
	quarto preview book/

serverefresh:
	Rscript --no-init-file -e 'renv::restore("book/", prompt = FALSE)'
	quarto preview book/ --cache-refresh

clean:
	$(RM) -r book/_book book/.quarto book/site_libs;\
	find . -name "*.ps" -type f -delete;
	find . -name "*.dvi" -type f -delete;
	find . -type d -name "*_files" -exec rm -rf {} \;
	find . -type d -name "*_cache" -exec rm -rf {} \;

html:
	Rscript --no-init-file -e 'renv::restore("./book/", prompt = FALSE)'
	quarto render book/ --to html

pdf:
	Rscript --no-init-file -e 'renv::restore("./book/", prompt = FALSE)'
	quarto render book/ --to pdf

names:
	Rscript -e 'mlr3book::name_chunks_mlr3book()'

bibtex:
	biber --tool --output-align --output-indent=2 --output-fieldcase=lower book/book.bib -O book/book.bib
	rm book/book.bib.blg
