ifndef PDFVIEWER
	PDFVIEWER=mupdf
endif

CONTAINER=latexdockercmd.sh /bin/sh -c
PDFLATEX_BIN=pdflatex
PDFLATEX_OPTS=-shell-escape -halt-on-error
MAKEGLOSSARIES_BIN=makeglossaries
BIBTEX_BIN=bibtex

.PHONY: all debug debugcmd clean clean-src clean-pdf show show-pr

default: p.pdf clean-src

all: p.pdf clean-src

p.pdf: p.tex glossar.tex verzeichnis.bib
	$(CONTAINER) "$(PDFLATEX_BIN) $(PDFLATEX_OPTS) p.tex && $(MAKEGLOSSARIES_BIN) p && $(BIBTEX_BIN) p && \
		$(PDFLATEX_BIN) $(PDFLATEX_OPTS) p.tex && $(MAKEGLOSSARIES_BIN) p && $(PDFLATEX_BIN) $(PDFLATEX_OPTS) p.tex"

inhalt_begin.pdf: p.pdf
	pdfseparate -f 1 -l 7 p.pdf cut%d.pdf && pdfunite cut*.pdf inhalt_begin.pdf && rm cut*.pdf

inhalt_end.pdf: p.pdf
	pdfseparate -f 46 -l 50 p.pdf cut%d.pdf && pdfunite cut*.pdf inhalt_end.pdf && rm cut*.pdf

inhalt.pdf: inhalt_begin.pdf inhalt_end.pdf
	pdfunite inhalt_begin.pdf inhalt_end.pdf inhalt.pdf && rm inhalt_begin.pdf inhalt_end.pdf

pr.pdf: pr.tex
	$(CONTAINER) "$(PDFLATEX_BIN) $(PDFLATEX_OPTS) pr.tex && $(PDFLATEX_BIN) $(PDFLATEX_OPTS) pr.tex"

debug: debugcmd clean-src

debugcmd: p.tex glossar.tex verzeichnis.bib
	$(CONTAINER) "$(PDFLATEX_BIN) $(PDFLATEX_OPTS) p.tex && $(MAKEGLOSSARIES_BIN) p && $(BIBTEX_BIN) p"

clean: clean-src clean-pdf

clean-src:
	rm -f p.aux p.log p.out p.toc p.glg p.glo p.gls p.ist p.lof \
		p.nav p.out p.snm p.toc p.vrb p.acn p.acr p.alg p.bbl p.blg p-blx.bib p.dvi p.lol p.pyg p.run.xml p.glsdefs \
		pr.aux pr.log pr.out pr.toc pr.glg pr.glo pr.gls pr.ist pr.lof \
		pr.nav pr.out pr.snm pr.toc pr.vrb pr.acn pr.acr pr.alg pr.bbl pr.blg p-blx.bib pr.dvi pr.lol pr.pyg pr.run.xml pr.glsdefs \
		p-gnuplottex-fig*

clean-pdf:
	rm -f p.pdf pr.pdf

show: p.pdf clean-src
	$(PDFVIEWER) p.pdf
show-pr: pr.pdf clean-src
	$(PDFVIEWER) pr.pdf