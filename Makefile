TALK_NAME	:= mala-skala-april-2018

# Variables for compilation
LATEX		:= latex
PDFLATEX	:= pdflatex
BIBTEX		:= bibtex
PDFCROP		:= pdfcrop
MPOST		:= mpost
PYTHON		:= python3

TALK_SRC	:= DHarries_E6_dark_matter.tex

TALK_FIGS_DIR	:= figures

TALK_FIGS	:= figures
TALK_DIAGS_DIR	:= $(TALK_FIGS_DIR)

TALK_FEYNMP	:= \
		$(TALK_DIAGS_DIR)/dmsignals.pdf

TALK_FIGS	:= \
		$(TALK_FIGS_DIR)/bbn.pdf \
		$(TALK_FIGS_DIR)/bulletcluster.jpg \
		$(TALK_FIGS_DIR)/cmb_power_spectrum.pdf \
		$(TALK_FIGS_DIR)/dmcandidates.pdf \
		$(TALK_FIGS_DIR)/ezssm_bino_fraction.pdf \
		$(TALK_FIGS_DIR)/ezssm_direct_detection.pdf \
		$(TALK_FIGS_DIR)/freezeout.pdf \
		$(TALK_FIGS_DIR)/matter_power_spectrum.pdf \
		$(TALK_FIGS_DIR)/rotation_curves.pdf \
		$(TALK_FIGS_DIR)/susyparticles_sm.png \
		$(TALK_FIGS_DIR)/uk_logo.png \
		$(TALK_FIGS_DIR)/xenon1t_si_limit.pdf

TALK_EXPORTED := \
		$(TALK_SRC) \
		$(TALK_FEYNMP) \
		$(TALK_FIGS)

TALK_PDF	:= $(TALK_SRC:.tex=.pdf)

LATEX_TMP	:= \
		$(patsubst %.pdf, %.aux, $(TALK_PDF)) \
		$(patsubst %.pdf, %.log, $(TALK_PDF)) \
		$(patsubst %.pdf, %.toc, $(TALK_PDF)) \
		$(patsubst %.pdf, %.out, $(TALK_PDF)) \
		$(patsubst %.pdf, %.spl, $(TALK_PDF)) \
		$(patsubst %.pdf, %.nav, $(TALK_PDF)) \
		$(patsubst %.pdf, %.snm, $(TALK_PDF)) \
		$(patsubst %.pdf, %.blg, $(TALK_PDF)) \
		$(patsubst %.pdf, %.bbl, $(TALK_PDF)) \
		$(patsubst %.pdf, %.aux, $(TALK_FEYNMP)) \
		$(patsubst %.pdf, %.log, $(TALK_FEYNMP)) \
		$(patsubst %.pdf, %.1, $(TALK_FEYNMP)) \
		$(patsubst %.pdf, %.t1, $(TALK_FEYNMP)) \
		$(patsubst %.pdf, %.mp, $(TALK_FEYNMP))

.PHONY: all all-pdf clean distclean talk-zip talk-tarball

all: all-pdf

all-pdf: $(TALK_PDF)

clean:
	-rm -f $(LATEX_TMP)

distclean: clean
	-rm -f $(TALK_FEYNMP)
	-rm -f $(TALK_PDF)

$(TALK_FEYNMP): $(TALK_DIAGS_DIR)/%.pdf: $(TALK_DIAGS_DIR)/%.tex
	cd $(TALK_DIAGS_DIR) && \
	$(PDFLATEX) $*.tex && \
	$(MPOST) $*.mp && \
	$(PDFLATEX) $*.tex && \
	$(PDFLATEX) $*.tex && \
	$(PDFCROP) $*.pdf $*.pdf


$(TALK_PDF): $(TALK_SRC) $(TALK_FIGS) $(TALK_FEYNMP)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

talk-zip: $(TALK_PDF)
	zip -r $(TALK_NAME).zip $(TALK_EXPORTED)

talk-tarball: $(TALK_PDF)
	tar -czf $(TALK_NAME).tar.gz $(TALK_EXPORTED)
