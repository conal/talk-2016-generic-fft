all: dot-r2-c.pdf dot-r3-d.pdf powers-rt4-no-opt.pdf powers-rt4.pdf \
     powersp-rb3-c.pdf powersp-rb4-c.pdf dft-rb2.pdf dft-rb3.pdf dft-rb4.pdf

# twiddles-rb2-rb3.pdf

%.pdf: %.dot Makefile
	dot -Tpdf $< -o $@

%.svg: %.dot Makefile
	dot -Tsvg $< -o $@

%.png: %.dot
	dot -Gdpi=200 -Tpng $< -o $@

figures/%.jpg: %.dot
	dot -Gdpi=200 -Tjpg $< -o $@

%.see: %
	open $<

.PRECIOUS: %.pdf
