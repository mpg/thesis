all: memoire.pdf front.pdf back.pdf

CLS = mpg-preth.cls

memoire.pdf: memoire.tex main.tex ?-*.tex thanks.tex these.bib $(CLS)
	latexmk $<

front.pdf: front.tex i-title.tex $(CLS)
	latexmk $<

back.pdf: back.tex $(CLS)
	latexmk $<

.PHONY: clean

clean:
	latexmk -c front back slides handout
