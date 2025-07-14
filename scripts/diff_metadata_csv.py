import csv
import argparse


def load_metadata(path):
    datas = {}

    with open(path, "r", encoding="utf-8") as f:
        reader = csv.reader(f)

        for i, row in enumerate(reader):
            if i == 0:
                continue

            datas[row[0]] = row

    return datas


p = argparse.ArgumentParser()

p.add_argument("prev_metadata_file")
p.add_argument("metadata_file")
p.add_argument("out_file")

args = p.parse_args()

previous = load_metadata(args.prev_metadata_file)
current = load_metadata(args.metadata_file)

with open(args.out_file, "w", encoding="utf-8") as f:
    w = csv.writer(f)

    w.writerow(["file_name", "name", "aliases"])

    for id, data in current.items():
        if id not in previous:
            w.writerow(data)
