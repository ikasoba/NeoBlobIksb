SOURCES = $(wildcard categories/*.svg) $(wildcard categories/**/*.svg)
IMAGES = $(SOURCES:.svg=.png)

all: $(IMAGES)

clean:
	rm -rf $(IMAGES) meta.json neoblobiksb.zip
	
%.png:
	inkscape -z -w 192 -h 192 --export-type=png $(@:.png=.svg)

meta.json:
	@python3 scripts/create_meta_json.py metadata.csv EMOJI_COPYRIGHT.txt EMOJI_CATEGORY.txt meta.json

neoblobiksb.zip: $(IMAGES) meta.json
	zip -j neoblobiksb.zip meta.json $(IMAGES)
