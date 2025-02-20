all: install serve

.PHONY : help
help :
	@echo "clean				: Remove auto-generated files."
	@echo "bibtex				: Reformats the bibtex file."

clean:
	$(RM) -r book/_book book/.quarto book/site_libs;\
	find . -name "*.ps" -type f -delete;
	find . -name "*.dvi" -type f -delete;
	find . -type d -name "*_files" -exec rm -rf {} \;
	find . -type d -name "*_cache" -exec rm -rf {} \;

bibtex:
	biber --tool --output-align --output-indent=2 --output-fieldcase=lower book/book.bib -O book/book.bib
	rm book/book.bib.blg
