#!/usr/bin/env python3

"""A code that finds the best allignent for two strands of fasta files"""
__version__ = '0.0.1'

import sys
import csv



def import_values(file_1, file_2):
    filepath_1 = f"data/{file_1}"
    filepath_2 = f"data/{file_2}"
    with open(filepath_1, "r") as f:
        lines = f.readlines()
        seq1 = ''.join(line.strip() for line in lines if not line.startswith('>'))
    with open(filepath_2, "r") as f:
        lines = f.readlines()
        seq2 = ''.join(line.strip() for line in lines if not line.startswith('>'))
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1 # swap the two lengths

    return(s1, s2, l1, l2)


# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score


def find_best_score(s1, s2, l1, l2):
    my_best_align = None
    my_best_score = -1

    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # think about what this is doing!
            my_best_score = z 
    print(f"{my_best_align}\n{s1}\nBest score: {my_best_score}")
    result = f"{my_best_align}\n{s1}\nBest score: {my_best_score}"
    return result 



def main(argv):
    if len(sys.argv) != 3:
        # Default files if no arguments given
        s1, s2, l1, l2 = import_values("407228326.fasta", "407228412.fasta")
    else:
        # Use command-line arguments
        s1, s2, l1, l2 = import_values(sys.argv[1], sys.argv[2])    
    with open( '../results/aligned_seq.txt', 'w') as f:
        f.write(find_best_score(s1, s2, l1, l2))    
    return(0)


if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
