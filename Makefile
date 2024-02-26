FILENAME=main

DEFAULTS_FILE=resources/pandoc/defaults.yaml
BUILDDIR=build

ALL_RESOURCE_FILES=$(shell find resources -type f| sed 's/ /\\ /g')
HTMLDIR=$(BUILDDIR)

REVEAL_DIR=resources/reveal

THEMEDIR=resources/cleanpurple
THEMENAME=cleanpurple
USE_CUSTOM_THEME=True

ifeq ($(USE_CUSTOM_THEME), True)
	THEME_TARGET=resources/headers/custom.css
else
	THEME_TARGET=resources/headers/$(THEMENAME).css
endif

SASS_INCLUDES=-I $(REVEAL_DIR)/css/theme/ -I $(THEMEDIR)


all: $(FILENAME).html

$(FILENAME).pdf: $(BUILDDIR)/$(FILENAME).pdf
	cp $< $@
$(FILENAME).html: $(BUILDDIR)/$(FILENAME).html
	cp $< $@

%/resources: resources | $(BUILDDIR)
	cd $*;  ln -s ../resources .

$(BUILDDIR)/%.html: %.md $(THEME_TARGET) $(ALL_RESOURCE_FILES)
	mkdir -p "$(shell dirname "$@")"
	pandoc "$<" \
	--defaults $(DEFAULTS_FILE) \
	--output="$@"

resources/headers/$(THEMENAME).css: $(THEMEDIR)/dist/$(THEMENAME).css
	cp $< $@

$(THEMEDIR)/dist/$(THEMENAME).css: $(THEMEDIR)/$(THEMENAME).scss 
	make -C $(dir $<)

resources/headers/custom.css: resources/custom_theme/custom.scss
	sass $(SASS_INCLUDES) $< $@

serve: $(HTML_TARGETS) | $(BUILDDIR)/resources
	cd $(HTMLDIR);python -m http.server

clean:
	rm -rf $(BUILDDIR)
