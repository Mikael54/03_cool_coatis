## 03_Cool_Coatis

## Description
- **align_seqs_better.py**
    - This script takes in two DNA sequences by sliding the shorter across the longer and scoring matches. Records *all* equally-best alignments, saves a human-readable report and a pickle file.  
    - The main argument that will check for user input when the script is called and will try ./data/seq1.fasta and ./data/seq2.fasta if those are missing. If those are missing, it falls back to two built-in example sequences so it still runs.  
    - Outputs (created under ./results/):  
        - alignment_results.txt : human-readable summary  
        - alignment_results.pkl : python pickle with the full results dict  


- **align_seqs_fasta.py**
    - This has multiple functions to import and find the best alignment of two files, which are expected to be in the csv format   
    - In the main argument which calls all of these functions allows for the user to provide 2 files to align or to use two built-in defaults  
    - Output: "aligned_seq.txt" that contains best alignment and written to the results folder  


- **oaks_debugme.py**  
    - This script takes in a data file ('TestOaksData.csv') that contains taxonomy information for a number of species and returns an output that contains just the name of oaks.  
    - The script is robust in that it allows for some misspellings of the oak genus while also employing doctests to ensure that the script handles such cases as expected.
    - Output: JustOaksData.csv which contains the a header and the oaks species found in the original output. 

## Languages 
- Python  
- R  
- LaTeX  

## Authors
Avery Chen  
    leyu.chen25@imperial.ac.uk  
  
Ore Solanke  
    ore.solanke25@imperial.ac.uk  
      
Daniel Zhu  
    haotian.zhu21@imperial.ac.uk  
      
Mikael Minten  
    mikael.minten25@imperial.ac.uk  
      
Hanxiao Wang  
    hanxiao.wang25@imperial.ac.uk    


