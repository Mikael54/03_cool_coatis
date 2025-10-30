#!/usr/bin/env python3

## imports 
import sys 


##functions
def read_seqs_from_file(fasta1, fasta2):
    # create empty strings (one for each fasta file) & empty list to hold starting indices of each fasta seq
    seq1 = ""
    seq2 = "" 

    #read in file
    with open(fasta1,'r') as f1: #tryptase fasta
        for line in f1.readlines()[1:]:
            line = line.replace("\n", "") 
            if (',' in line):
                line=line.replace(",", "")
            #print(line)
            seq1=seq1+line
    #print(seq1)

    with open(fasta2,'r') as f2:
        for line in f2.readlines()[1:]:
            line = line.replace("\n", "") 

            seq2=seq2+line
    # then:
    # assign the longer sequence s1, and the shorter to s2
    # l1 is length of the longest, l2 that of the shortest
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
def calculate_score(s1, s2, l1, l2, startpoint): #i will be passed in by next function with its own for loop
    matched = "" # to hold string displaying alignements
    score = 0
    for i in range(l2): ## so will iterate through all of the letters in l2
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"
    return score


#function that finds the best alignment
def find_best_alignment():
    s1, s2, l1, l2 = read_seqs_from_file()
    my_best_align = None
    my_best_score = -1

    for i in range(l1): # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2 # this will put 'i' number of periods followed by the shorter sequence (s2)
            my_best_score = z 
            i_pos=i
    
    best_alignment = f"Pos: {i_pos}; Alignment: {my_best_align} \n Other seq: {s1} \n Best score: {my_best_score}"
    with open ('../results/best_alignment.txt', 'w', newline='') as textfile:
        textfile.write(best_alignment)

    return(best_alignment)

def main(argv):
    print(find_best_alignment())
    return 0


## the function will not print/run if the below is not included !
if (__name__ == "__main__"):
    """Makes sure the 'function' is called from command line"""
    status = main(sys.argv)
    sys.exit(status)

