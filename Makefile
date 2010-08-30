SOURCES=$(wildcard *.tex)
BASENAMES=$(basename $(SOURCES))
ALL=$(filter-out normes-mesures, $(BASENAMES))

all: $(addsuffix .pdf, $(ALL))

%.pdf: %.tex
	latexmk -pdf $<

clean:
	latexmk -c
	rm -f -- *.bbl *-blx.bib *.xml

mrproper: clean
	latexmk -C

.PHONY: clean mrproper all
