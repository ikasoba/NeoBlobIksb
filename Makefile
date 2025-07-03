SOURCES = $(wildcard categories/*.svg) $(wildcard categories/**/*.svg)
IMAGES = $(SOURCES:.svg=.png)

all: $(IMAGES)

clean:
	rm -rf $(IMAGES)
	
%.png:
	inkscape --export-type=png $(@:.png=.svg)
