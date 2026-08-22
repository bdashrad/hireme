# SHELL := /bin/bash

OUT_DIR=output
IN_DIR=resume_source
STYLES_DIR=styles
STYLE=chmduquesne_purple
TEMPLATES_DIR=templates

all: html pdf docx rtf txt md

pdf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone --wrap=none --template $(TEMPLATES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			--variable papersize=letter \
			--metadata-file=$(IN_DIR)/metadata.yaml \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		mtxrun --path=$(OUT_DIR) --result=$$FILE_NAME.pdf --script context $$FILE_NAME.tex > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
	done

html: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.html; \
		pandoc --standalone --wrap=none --include-in-header $(STYLES_DIR)/$(STYLE).css \
			--lua-filter=pdc-links-target-blank.lua \
			--from markdown --to html \
			--template $(TEMPLATES_DIR)/template.html5 \
			--metadata-file=$(IN_DIR)/metadata.yaml \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f ;\
	done

docx: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		TARGET_NAME=$$FILE_NAME.docx; \
		echo $$TARGET_NAME; \
		pandoc --standalone $$SMART $$f \
			--metadata-file=$(IN_DIR)/metadata.yaml \
			--output $(OUT_DIR)/$$TARGET_NAME; \
	done

rtf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		TARGET_NAME=$$FILE_NAME.rtf; \
		echo $$TARGET_NAME; \
		pandoc --standalone $$SMART $$f \
			--metadata-file=$(IN_DIR)/metadata.yaml \
			--output $(OUT_DIR)/$$TARGET_NAME; \
	done

txt: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		TARGET_NAME=$$FILE_NAME.txt; \
		echo $$TARGET_NAME; \
		pandoc --standalone $$SMART $$f \
			--metadata-file=$(IN_DIR)/metadata.yaml \
			--output $(OUT_DIR)/$$TARGET_NAME; \
	done

md:
	cp $(IN_DIR)/*.md $(OUT_DIR)/

init: dir version

dir:
	mkdir -p $(OUT_DIR)

version:
	PANDOC_VERSION=`pandoc --version | head -1 | cut -d' ' -f2 | cut -d'.' -f1`; \
	if [ "$$PANDOC_VERSION" -eq "2" ]; then \
		SMART=-smart; \
	else \
		SMART=--smart; \
	fi \

clean:
	rm -f $(OUT_DIR)/*

publish:
	rsync -avP $(OUT_DIR)/* /var/www/hireme/
