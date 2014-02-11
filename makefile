COFFEEC = coffee
SASSC = sass
HANDLEBARSC = handlebars

# Build app package
APPSRC = coffee/file.coffee \
	coffee/viz.coffee \
	coffee/app.coffee

APPOBJ = ${APPSRC:.coffee=.js}
APPOUT = js/app.js

$(APPOUT): $(APPOBJ)
	awk 'FNR==1{print ""}1' $^ > $@

%.js: %.coffee
	$(COFFEEC) -bc --map $<

.PHONY: script
script: $(APPOUT)

# Build stylesheets
STYLESRC = $(wildcard stylesheet/*.scss)
STYLEOBJ = ${STYLESRC:.scss=.css}
STYLEOUT = css/compiled.css

$(STYLEOUT): $(STYLEOBJ)
	awk 'FNR==1{print ""}1' $^ > $@

%.css: %.scss
	$(SASSC) -C $< > $@

.PHONY: style
style: $(STYLEOUT)

.PHONY: all
all: script style 

.DEFAULT_GOAL := all

.PHONY: clean
clean:
	-rm $(STYLEOBJ)
	-rm $(STYLEOUT)
