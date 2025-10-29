#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv
from pathlib import Path
import doctest


# define a function 
def is_an_oak(name):
    """
    Check if the first word is 'quercus' 

    >>> is_an_oak('Quercus')
    True
    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('Fagus sylvatica')
    False
    >>> is_an_oak('Quercuss') 
    False
    """
    if not name:
        return False

    # remove spaces and take the first word
    first_word = name.strip().split()[0].lower()
    return first_word == "quercus"


# main code
def main():
    """Read csv, find oaks, and save them to a new file."""

    # find Data folder 
    root = Path(__file__).resolve().parent.parent
    if (root / "Data").exists():
        data_dir = root / "Data"
    else:
        data_dir = root / "data"

    in_file = data_dir / "TestOaksData.csv"
    out_file = data_dir / "JustOaksData.csv"

    print("Reading file:", in_file)

    # open input and output file
    with in_file.open(newline='', encoding='utf-8') as f_in, \
         out_file.open('w', newline='', encoding='utf-8') as f_out:

        reader = csv.reader(f_in)
        writer = csv.writer(f_out)

        # skip the header in input and write a new header in output
        header = next(reader)
        writer.writerow(["Genus", "Species"])

        count = 0
        for row in reader:
            if not row:
                continue

            genus = row[0]
            species = row[1]

            if is_an_oak(genus):
                writer.writerow([genus, species])
                count += 1

    print("Found", count, "oak trees.")
    print("Saved new file:", out_file)


# run and tests 
if __name__ == "__main__":
    main()
    print("\nNow running doctest...\n")
    doctest.testmod(verbose=True)
