NODE_MODULES_BASE=node_modules
BIN_COFFEE=$(NODE_MODULES_BASE)/.bin/coffee
BIN_UGLIFYJS=$(NODE_MODULES_BASE)/.bin/uglifyjs

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


all: html css js $(ZIP)

html: $(HTML)
	staticjinja build --srcpath=$(TEXT_DIR)
js: $(MINJS) $(JS)
css: $(MINCSS) $(CSS)

$(ZIP): $(LOGO)
	cd ./assets && zip -9DJor u360-logo.zip $(subst ./assets/,,$(LOGO))

server:
	python -m SimpleHTTPServer

clean:
	find . -maxdepth 1 -name "*.h?ml" -delete
	rm -f $(HTML) $(MINJS) $(JS) $(MINCSS) $(CSS) $(ZIP)

.PHONY: html css js
