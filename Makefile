all: html css js

NODE_MODULES_BASE=node_modules
BIN_COFFEE=$(NODE_MODULES_BASE)/.bin/coffee
BIN_FLATC=flatc
BIN_HAML=$(firstword $(HAML_PATH) haml)
BIN_UGLIFYJS=$(NODE_MODULES_BASE)/.bin/uglifyjs

JS_DIR=js
CSS_DIR=css

.SUFFIXES: .haml .html
.haml.html:
	@if which $(BIN_HAML) >/dev/null; then\
		echo $(BIN_HAML) -f html5 -t ugly $< $@;\
		$(BIN_HAML) -f html5 -t ugly $< $@;\
	else\
		echo haml is not exists: no build $<;\
		exit 1;\
	fi
HAML = $(shell find . -name "*.haml")
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
	compass compile $< -c $(CSS_DIR)/config.rb
.SUFFIXES: .sass .min.css
.sass.min.css:
	compass compile --environment production $< -c $(CSS_DIR)/config.rb
	mv $*.css $@
SASS = $(wildcard $(CSS_DIR)/*.sass)
CSS = $(SASS:.sass=.css)
MINCSS = $(SASS:.sass=.min.css)

html: $(HTML)
js: $(MINJS) $(JS)
css: $(MINCSS) $(CSS)
