SHELL=/bin/bash
TEX=tex -fmt=latex
LATEX=latex
# TeX Live 2016: ftp://tug.org/historic/systems/texlive/2016/texlive2016.iso
LATEX=$(TEX)
.PHONY: thesis
thesis: main.pdf
	make clean
%.pdf: clean
	make fonts
	[ "$(LATEX)" != "$(TEX)" ] || sed -e 's/^thai loadhyph-th.tex$$/%/g; s/^georgian loadhyph-ka.tex$$/%/g' $(shell kpsewhich language.dat) > language.dat
	[ "$(LATEX)" != "$(TEX)" ] || tex -ini -jobname=latex -progname=latex -translate-file=cp227.tcx latex.ini
	[ "$(LATEX)" != "$(TEX)" ] || sed -e 's/^\\global\\UTFviii@hexdigit\\hexnumber@$$/\\global\\let\\UTFviii@hexdigit\\hexnumber@/g; s/^\\gdef\\UTFviii@splitcsname#1:#2\\relax{#2}}$$/\\gdef\\UTFviii@splitcsname#1:#2\\relax{#2}/g' $(shell kpsewhich utf8.def) > utf8.def
	#extractbb figures/*
	$(LATEX) $*
	bibtex $*
	$(LATEX) $*
	$(LATEX) $*
	dvipdfmx -f dvipdfmx.map -V 7 $*
.PHONY: fonts
fonts: arial.tfm arialbd.tfm ariali.tfm arialbi.tfm times.tfm timesbd.tfm timesi.tfm timesbi.tfm
	ln -sf fonts/simsun.ttc
	ttf2tfm simsun -q song@Unicode@
	echo "song@Unicode@ unicode simsun" >> dvipdfmx.map
	ln -sf fonts/simhei.ttf
	ttf2tfm simhei -q hei@Unicode@
	echo "hei@Unicode@ unicode simhei" >> dvipdfmx.map
	ln -sf fonts/simfang.ttf
	ttf2tfm simfang -q fang@Unicode@
	echo "fang@Unicode@ unicode simfang" >> dvipdfmx.map
%.tfm:
	ln -sf fonts/$*.ttf
	ttf2tfm $* -q -T T1-WGL4.enc -v $* $*
	vptovf $*
	echo "$* T1-WGL4 $*" >> dvipdfmx.map
.PHONY: clean
clean:
	rm -f *.{aux,bbl,blg,dat,def,dvi,fmt,log,map,out,tfm,ttc,ttf,toc,vf,vpl}
	#rm -f figures/*.xbb
