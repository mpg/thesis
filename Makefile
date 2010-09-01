SOURCES=$(wildcard *.tex)
BASENAMES=$(basename $(SOURCES))
ALL=$(BASENAMES)

all: $(addsuffix .pdf, $(ALL))

%.pdf: %.tex mpg-preth.cls
	latexmk -pdf $<

idee-pub.pdf: idee.tex

clean:
	latexmk -c
	rm -f -- *.bbl *-blx.bib *.xml

mrproper: clean
	latexmk -C

.PHONY: clean mrproper all
