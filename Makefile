FILENAME=main

DEFAULTS_FILE=resources/pandoc/defaults.yaml
BUILDDIR=build
PYTHON=../../ALT2024_ot_markov/.env/bin/python
# PYTHON=python

ALL_RESOURCE_FILES=$(shell find resources -type f| sed 's/ /\\ /g')
HTMLDIR=$(BUILDDIR)

THEMEDIR=$(HOME)/programmation/web/cleanpurple_revealjs_theme
THEMENAME=cleanpurple


all: $(FILENAME).html

$(FILENAME).pdf: $(BUILDDIR)/$(FILENAME).pdf
	cp $< $@
$(FILENAME).html: $(BUILDDIR)/$(FILENAME).html
	cp $< $@

%/resources: resources | $(BUILDDIR)
	cd $*;  ln -s ../resources .

$(BUILDDIR)/%.html: %.md resources/headers/$(THEMENAME).css $(ALL_RESOURCE_FILES)
	mkdir -p "$(shell dirname "$@")"
	pandoc "$<" \
	--defaults $(DEFAULTS_FILE) \
	--output="$@"

resources/headers/$(THEMENAME).css: $(THEMEDIR)/dist/$(THEMENAME).css
	cp $< $@

$(THEMEDIR)/dist/$(THEMENAME).css: $(THEMEDIR)/$(THEMENAME).scss
	make -C $(dir $<)

serve: $(HTML_TARGETS) | $(BUILDDIR)/resources
	cd $(HTMLDIR);python -m http.server

clean:
	rm -rf $(BUILDDIR)
