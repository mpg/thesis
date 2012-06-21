all: memoire.pdf front.pdf back.pdf

memoire.pdf: *.tex these.bib mpg-preth.cls
	latexmk memoire.tex

front.pdf: memoire.pdf
	pdftk $< cat 1 output $@

back.pdf: back.tex mpg-preth.cls
	latexmk $<
