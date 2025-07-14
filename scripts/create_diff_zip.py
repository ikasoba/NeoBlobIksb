import csv
import argparse
import glob
import os
import itertools
import zipfile

p = argparse.ArgumentParser()

p.add_argument("metadata_csv_file")
p.add_argument("meta_json_file")
p.add_argument("outname")

args = p.parse_args()

generated_files = {}

sources = itertools.chain(
    glob.glob("categories/*.png"),
    glob.glob("categories/**/*.png"),
    glob.glob("categories/animations/*.webp")
)

for path in sources:
    generated_files[os.path.basename(path)] = path

with zipfile.ZipFile(args.outname, "w", compression=zipfile.ZIP_DEFLATED) as zf:
    zf.write(args.meta_json_file, "meta.json")

    with open(args.metadata_csv_file, encoding="utf-8") as f:
        r = csv.reader(f)

        for i, row in enumerate(r):
            if i < 1:
                continue

            name = row[0]

            if name in generated_files:
                zf.write(generated_files[name], name)
