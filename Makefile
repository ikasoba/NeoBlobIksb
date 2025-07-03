SOURCES = $(wildcard categories/*.svg) $(wildcard categories/**/*.svg)
IMAGES = $(SOURCES:.svg=.png)

all: $(IMAGES)

clean:
	rm -rf $(IMAGES)
	
%.png:
	inkscape -z -w 192 -h 192 --export-type=png $(@:.png=.svg)
