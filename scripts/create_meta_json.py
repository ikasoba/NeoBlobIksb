import csv
import argparse
import re
import json

p = argparse.ArgumentParser()

p.add_argument("metadata_file")
p.add_argument("copyright_file")
p.add_argument("category_file")
p.add_argument("outname")

args = p.parse_args()

copyright = ""
with open(args.copyright_file, "r", encoding="utf-8") as f:
    copyright = f.read().rstrip()

category = ""
with open(args.category_file, "r", encoding="utf-8") as f:
    category = f.read().rstrip()

meta = { "emojis": [] }

with open(args.metadata_file, "r", encoding="utf-8") as f:
    reader = csv.reader(f)

    keys = []

    for i, row in enumerate(reader):
        if i == 0:
            keys = row
        else:
            o = {
                "downloaded": True,
                "emoji": {
                    "license": copyright,
                    "category": category
                }
            }

            for j, val in enumerate(row):
                if len(keys) <= j:
                    break

                k = keys[j]

                if k == "aliases":
                    o["emoji"][k] = re.split(r"\s+", val)
                elif k == "file_name":
                    o["fileName"] = val
                else:
                    o["emoji"][k] = val

            meta["emojis"].append(o)

with open(args.outname, "w") as f:
    json.dump(meta, f)
