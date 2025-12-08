# Group Work Contributions

**Assignment**: Group 03 — *Cool Coatis*  
**Group Members**: 
- **Ore Solanke** — ore.solanke25@imperial.ac.uk  
- **Mikael Minten** — mikael.minten25@imperial.ac.uk  
- **Daniel Zhu** — haotian.zhu21@imperial.ac.uk  
- **Avery Chen** — leyu.chen25@imperial.ac.uk  
- **Hanxiao Wang** — hanxiao.wang25@imperial.ac.uk  
**Submission Date**: 31 Oct 2025

## Individual Contributions

### Ore Solanke
**Role(s)**: 
- README.md contributor 
- Code consultant

**Specific Contributions**:
- Collaboration to write fasta/csv input functions in align_seqs_fasta file
- Assisted with setting up directory/branch structure for groupwork 
- Assisted with writing README.md


**Key commits**: 
- [`fc2cc69`] - Updating README periodically as group finished tasks for scripts
- [`7e01f94`] - Creating dummy files to demonstrate branching 

---

### Mikael Minten
**Role(s)**:
- Code developer  
- Github repository Manager
- Code Reviewer

**Specific Contributions**:
- Developed the `align_seqs_fasta` function to process FASTA files with support for command-line input arguments. Implemented default behavior to use sample data files when no input is provided.  
- Reviewed the `align_seqs_better` code and tested it, ensuring it had correct filepaths to both load the data and results.
- Reviewed the `pp_regress_loc.R` code and fixed a bug where all regressions had the same result. Then merged it with the ore_sol branch via pull request.
- Created a `.gitignore` file to exclude unnecessary and temporary files across multiple programming languages.  
- Managed repository maintenance tasks, including file cleanup (e.g., removal of `dummy.txt`) and merging three separate branches into the `main` branch.  
- Contributed to the writing and editing of the `contributions.md` documentation.  

**Key commits**: 

- [`e1a8e86`] (HEAD -> main, origin/main) Updating the gitignore file so that it ignores files inside folders and adding a gitkeep to the results folder. Also cleaned up the repo (removing unnesesary files).
- [`57bb06c`] Merge branch 'Mikael' into main. This included two other branches.  
- [`56cdf09`] Creating the  align sequences to have the ability to input any two files, with default files if none are given.  
- [`7f4f9c8`] Bug testing the align_seqs_better code and changing it so that it works from the /code directory,  instead of the main directory.  
- [`336cd13`]  Updated the code to resolve two issues: duplicate results appearing three times, and all results incorrectly sharing the same slope and intercept.

---

### Daniel Zhu
**Role(s)**: 
- Code Developer
- Documentation Contributor

**Specific Contributions**:
- Edited `oaks_debugme.py` to ensure the program correctly excludes the header line (`next(taxa)`) before processing species names.  
- Verified the functionality of `is_an_oak()` through **doctests** and additional print-debugging.  
- Managed file cleanup (removing redundant folders) and merging the `daniel` branch into `main`.
- Uploaded the **CONTRIBUTIONS.md** template for the group to edit and filled in group information.


**Key commits**: 
- [`d9d8615`]— Added the Missing Oaks script and implemented header-skipping logic.  
- [`bb7091b`]— Updated `JustOaksData.csv` after running `oaks_debugme.py`.  
- [`5b1b7eb`]— Merged branch `daniel` with `main`.  
- [`867dab3`]— Uploaded the `CONTRIBUTIONS.md` template for collaborative editing.

---

### Avery Chen
**Role(s)**:
- Code Developer & Optimisation
- Documentation Contributor

**Specific Contributions**:
- Worked on “Missing Oaks Problem – Part 2”, focusing on improving file handling and code readability.
- Edited find_oaks_new.py to make the program correctly skip the input header line and add the header “Genus, species” in the output CSV file.
- Reviewed and organised the merged version of the group code to ensure it runs smoothly after integration.
- Added clear inline comments and print statements to make the script easier for others to read and understand.
- Wrote and ran doctests to check that the is_an_oak() function works properly.

**Key commits**: 
- [`293d21b`] — Finished my part of writing headers of “Genus and species” into the output CSV file. Added comments to make the code more readable.

---
### Hanxiao Wang
**Role(s)**: 
-Code Developer
-Data Analysis Specialist


**Specific Contributions**:
- Implemented and tested Python functions such as foo_1() to foo_6() for control flow and recursion exercises (e.g., factorial computation using loops and recursion).
- Contributed to explaining how local and global variables behave in different Python scopes within our shared code files.
- Performed iterative testing of loops, control flow tools, and comprehensions to verify correctness and prevent infinite loops.
- Assisted teammates in understanding the difference between mutable and immutable objects (lists vs tuples).

**Key commits**: 
- [`8450c7e`] Merge branch 'hanxiaoang' into Mikael

---

## Collaboration Process

**Meeting Schedule**: The group met once a week, with one in-person meeting in Week 4 and another in Week 5 to discuss progress. Communication between meetings was maintained through a WhatsApp group chat, email, and occasional Microsoft Teams calls for quick coordination and sharing updates.

**Work Distribution Strategy**: 
- **Mikael** worked on **FASTA Question 1**
- **Hanxiao** worked on **FASTA Question 2**, **Mikael** reviewed it.
- **Daniel** and **Avery** focused on the **Missing Oaks** question.

Each member was responsible for writing and testing their respective scripts, followed by code review sessions to ensure consistency and functionality before merging.

**Key Decisions**: The team agreed to use individual Git branches for development to avoid code conflicts. After testing and peer review, each branch was merged into the main branch via pull requests. This ensured version control, clear contribution tracking, and minimal risk of overwriting others’ work.

**Challenges and Solutions**: A few merge conflicts occurred during integration due to overlapping edits in shared files. These were resolved by comparing versions together and confirming the correct final code before merging.

## Code Review Summary


**Pull Requests**:
- PR #1: Mikael Minten reviewed the pp_regress_loc.R located in the ore_sol branch, and fixed a bug in the code in the mikael_pp_regress_loc branch. The changes were pushed back into the ore_sol branch via a pull request. Reviewed by: Ore Solanke


## Testing and Quality Assurance

Within our two sub-groups, we reviewed and discussed each other's code. We also checked for robustness by ensuring things like our file names were all the same and that our functions ran similarly. 

## Declaration

We declare that the above contributions are accurate and that all team members participated actively in this group work.

**Signatures** (or typed names with date):
- [Team Member 1]: Ore Solanke          **Date**: 31 Oct 2025
- [Team Member 2]: Mikael Minten        **Date**: 31 Oct 2025
- [Team Member 3]: Daniel Zhu           **Date**: 31 Oct 2025
- [Team Member 4]: Avery Chen           **Date**: 31 Oct 2025
- [Team Member 5]: Hanxiao Wang         **Date**: 31 Oct 2025
