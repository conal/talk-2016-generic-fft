TARG = generic-fft

.PRECIOUS: %.tex %.pdf %.web

all: $(TARG).pdf

see: $(TARG).see

dots = $(wildcard Figures/circuits/*.dot)
pdfs = $(addsuffix .pdf, $(basename $(dots)))

%.pdf: %.tex $(pdfs) Makefile
	pdflatex $*.tex

# --poly is default for lhs2TeX

%.tex: %.lhs macros.tex mine.fmt Makefile
	lhs2TeX -o $*.tex $*.lhs

showpdf = open -a Skim.app

%.see: %.pdf
	${showpdf} $*.pdf

%.pdf: %.dot Makefile
	dot -Tpdf $< -o $@

pdfs: $(pdfs)

clean:
	rm $(TARG).{tex,pdf,aux,nav,snm,ptb}

web: web-token

STASH=conal@conal.net:/home/conal/web/talks
web: web-token

web-token: $(TARG).pdf
	scp $? $(STASH)/$(TARG)-lambdajam-2015.pdf
	touch $@
