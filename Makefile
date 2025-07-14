PYTHON3 = python3

SOURCES = $(filter-out $(wildcard categories/animations/*.svg),$(wildcard categories/*.svg) $(wildcard categories/**/*.svg))
IMAGES = $(SOURCES:.svg=.png)

ANIMATION_SOURCES = $(wildcard categories/animations/*.svg)
ANIMATION_IMAGES = $(ANIMATION_SOURCES:.svg=.png)
ANIMATIONS = $(ANIMATION_SOURCES:.svg=.webp)

all: $(IMAGES) $(ANIMATION_IMAGES) $(ANIMATIONS)

clean:
	rm -rf $(IMAGES) $(ANIMATIONS:.webp=)/ $(ANIMATION_IMAGES) $(ANIMATIONS) meta.json neoblobiksb.zip diff/ neoblobiksb_diff.zip

%.png:
	inkscape -z -w 192 -h 192 --export-type=png $(@:.png=.svg)

categories/animations/%.webp: categories/animations/%.png
	mkdir -p $(@:.webp=)
	cd $(dir $@) && synfig -i $(notdir $(@:.webp=.sifz)) -t png -w 128 -h 128 `cat $(notdir $(@:.webp=.txt))` -o $(notdir $(@:.webp=))/frame.png
	ffmpeg -r 24 -i $(@:.webp=)/frame.%04d.png -loop 0 $@

meta.json:
	@$(PYTHON3) scripts/create_meta_json.py metadata.csv EMOJI_COPYRIGHT.txt EMOJI_CATEGORY.txt meta.json

neoblobiksb.zip: $(IMAGES) $(ANIMATIONS) meta.json
	zip -j neoblobiksb.zip meta.json $(IMAGES) $(ANIMATIONS)

# generate diff

DIFF_TAG =

diff/:
	mkdir -p diff/

diff/prev_metadata.csv: diff/
	git show $(DIFF_TAG):metadata.csv > diff/prev_metadata.csv

diff/metadata.csv: diff/prev_metadata.csv
	@$(PYTHON3) scripts/diff_metadata_csv.py diff/prev_metadata.csv metadata.csv diff/metadata.csv

diff/meta.json: diff/metadata.csv
	@$(PYTHON3) scripts/create_meta_json.py diff/metadata.csv EMOJI_COPYRIGHT.txt EMOJI_CATEGORY.txt diff/meta.json

neoblobiksb_diff.zip: $(IMAGES) $(ANIMATIONS) diff/meta.json
	@$(PYTHON3) scripts/create_diff_zip.py diff/metadata.csv diff/meta.json neoblobiksb_diff.zip
