up:
	cd ../..; make

# Cap the size so that LaTeX doesn't choke.
%.pdf: %.dot Makefile
	dot -Tpdf -Gsize=10,10 $< -o $@

# Remove page dimensions, to make the results self-scaling
%.svg: %.dot Makefile
	dot -Tsvg $< | sed -e 's/<svg width.*/<svg/'> $@

%.png: %.dot
	dot -Gdpi=200 -Tpng $< -o $@

%.jpg: %.dot
	dot -Gdpi=200 -Tjpg $< -o $@

%.see: %
	open $<

.PRECIOUS: %.pdf
