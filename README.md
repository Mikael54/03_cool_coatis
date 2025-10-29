# 03_cool_coatis
Name: Avery L Chen
CID: 06053380
# My part in the groupwork
- My part in this group project was to finish “Missing Oaks Problem – Part 2”. This part was about fixing the code that reads a CSV file and finds oak trees. I needed to make the program skip the header in the input file and also add the header line (“Genus, species”) in the new output file.I also made sure the program only writes the rows where the genus is Quercus (oak trees).
# Scripts included
- # find_oaks_new.py
    This is the new script I wrote for my part.
    It has three main parts:
    - Function is_an_oak() — checks if the first word in the name is “Quercus”. It ignores capital letters and spaces.
    - Main program — reads TestOaksData.csv, skips the header, finds oak trees, and writes them into a new file called JustOaksData.csv.
    - Doctest — runs small tests at the end to make sure is_an_oak() works correctly.

- # TestOaksData.csv
    This is the input file that contains all plant names with their genus and species.

- # JustOaksData.csv
    This is the output file created by the script. It only includes the oak trees and has the correct header at the top.

# Mistakes I made during this task
    When I first started, my script did not skip the header line in the CSV file. So, the program printed the words “Genus” and “species” as if they were real tree names. I also forgot to write the header in the output file at first. Another small mistake was that I used startswith('quercs') instead of startswith('quercus'), which made the function miss all the oak trees. After I found these bugs, I changed the function to check only the first word and made sure the spelling was exactly “quercus”.

# Summary
- # In this task, I learned how to:
    - Use the csv module to read and write data files,
    - Skip header rows and write new ones,
    - Use string functions like .strip() and .split() to clean text,
    - Write and run doctests to check my function automatically.
- # My final script works:
    - it finds all oak trees, writes the correct header, and passes all tests.