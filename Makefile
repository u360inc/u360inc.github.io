LOCALES=en si ta


all: html css js $(ZIP)

LOCALEDIR=locale
TRANSRATE_KEYWORD="_([^)]*)"
TRANSRATE=$(patsubst $(TEXT_DIR)/%,%,$(patsubst %.haml,%.html,$(shell grep $(TRANSRATE_KEYWORD) $(HAML)|awk -F: '{print $$1}'|sort -u)))

NODE_MODULES_BASE=node_modules
BIN_COFFEE=$(NODE_MODULES_BASE)/.bin/coffee
BIN_UGLIFYJS=$(NODE_MODULES_BASE)/.bin/uglifyjs
BIN_BABEL=$(shell which pybabel)
BIN_STATICJINJA=assets/bin/build_staticjinja.py

JS_DIR=js
CSS_DIR=css
TEXT_DIR=text
ZIP=./assets/u360-logo.zip
LOGO=$(shell find ./assets/u360-logo -type f -name "*.png" -print -or -type f -name "*.svg" -print)

.SUFFIXES: .haml .html
.haml.html:
	bundle exec haml -f html5 -t ugly $< $@
HAML = $(shell find $(TEXT_DIR) -name "*.haml" -print)
HTML = $(HAML:.haml=.html)

.SUFFIXES: .coffee .js
.coffee.js:
	$(BIN_COFFEE) -c $<
.SUFFIXES: .js .min.js
.js.min.js:
	$(BIN_UGLIFYJS) --define PRODUCTION=0 -nc -m -r "$$" -o $@ $<
COFFEE = $(foreach dir,$(JS_DIR),$(wildcard $(dir)/*.coffee))
JS = $(COFFEE:.coffee=.js)
MINJS = $(JS:.js=.min.js)

.SUFFIXES: .sass .css
.sass.css:
	bundle exec compass compile $< -c $(CSS_DIR)/config.rb
.SUFFIXES: .sass .min.css
.sass.min.css:
	bundle exec compass compile --environment production $< -c $(CSS_DIR)/config.rb
	mv $*.css $@
SASS = $(wildcard $(CSS_DIR)/*.sass)
CSS = $(SASS:.sass=.css)
MINCSS = $(SASS:.sass=.min.css)

.SUFFIXES: .mapping .pot
.mapping.pot:
	$(BIN_BABEL) extract -k GetText --omit-header -o $@ -F $< $(TEXT_DIR)
	@for locale in $(LOCALES); do\
		subcommand=init;\
		if [ -e $(dir $@)$$locale/LC_MESSAGES/$(notdir $(basename $@)).po ]; then\
			subcommand="update";\
		fi;\
		cmd="$(BIN_BABEL) $$subcommand -D $(notdir $*) -i $@ -d $(LOCALEDIR) -l $$locale";\
		echo $$cmd;\
		$$cmd;\
	done
MAPPING=$(wildcard $(LOCALEDIR)/*.mapping)
POT=$(MAPPING:.mapping=.pot)
SVG:=$(shell find $(TEXT_DIR) -type f -name "*.svg" -print)
$(POT): Makefile $(MAPPING) $(HTML) $(SVG)

.SUFFIXES: .po .mo
.po.mo:
	$(BIN_BABEL) compile -d $(LOCALEDIR) -D $(notdir $*)
PO=$(foreach locale,$(LOCALES),$(foreach po,$(POT:.pot=.po),$(subst $(LOCALEDIR),$(LOCALEDIR)/$(locale)/LC_MESSAGES,$(po))))
MO=$(PO:.po=.mo)
$(PO): $(POT)
$(MO): $(POT)
$(LOCALE): $(MO)

html: $(HTML) $(MAPPING) $(POT) $(MO)
	LANGUAGE=ja $(BIN_STATICJINJA) build --srcpath=$(TEXT_DIR)
	$(foreach locale,$(LOCALES),mkdir -p $(locale) && LANGUAGE=$(locale) $(BIN_STATICJINJA) build --srcpath=$(TEXT_DIR) --outpath=$(locale);)
	rm -f $(foreach locale,$(LOCALES),$(addprefix $(locale)/,$(filter-out $(TRANSRATE),$(patsubst $(TEXT_DIR)/%,%,$(HTML) $(HAML)))))
	rm -f $(patsubst $(TEXT_DIR)/%,%,$(HAML))
js: $(MINJS) $(JS)
css: $(MINCSS) $(CSS)

$(ZIP): $(LOGO)
	cd ./assets && zip -9DJor u360-logo.zip $(subst ./assets/,,$(LOGO))

server:
	python -m SimpleHTTPServer

clean:
	find . -name .DS_Store -delete
	find . -maxdepth 1 -name "*.h?ml" -delete
	rm -f $(HTML) $(MINJS) $(JS) $(MINCSS) $(CSS) $(ZIP) $(MO) $(POT)
	rm -rf $(LOCALES) svg

.PHONY: html css js
