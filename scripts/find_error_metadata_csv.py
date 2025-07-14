import csv
import argparse
import re
import glob
import os
import itertools

p = argparse.ArgumentParser()

p.add_argument("metadata_file")

args = p.parse_args()

source_names = set()

sources = itertools.chain(
    glob.glob("categories/*.svg"),
    glob.glob("categories/**/*.svg")
)

for name in sources:
    source_names.add(re.sub(r"\.[a-z]+$", "", os.path.basename(name)))

emoji_names = set()

with open(args.metadata_file, "r", encoding="utf-8") as f:
    reader = csv.reader(f)

    for i, row in enumerate(reader):
        if i == 0:
            continue

        name = re.sub(r"\.[a-z]+$", "", row[0])

        emoji_names.add(name)

for source_name in source_names:
    if source_name not in emoji_names:
        print("not included:", source_name)

for emoji_name in emoji_names:
    if emoji_name not in source_names:
        print("not found:", emoji_name)
