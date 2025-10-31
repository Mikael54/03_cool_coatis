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
**Role(s)**: [e.g., Lead developer, Data analysis specialist, Testing coordinator]

**Specific Contributions**:
- [Describe specific code/functions written]
- [Describe documentation contributions]
- [Describe testing/debugging work]
- [Describe other contributions]

**Key commits**: [List 3-5 most significant commit hashes and brief descriptions]

---

### Mikael Minten
**Role(s)**:
- Code developer  
- Github repository Manager
- Code Reviewer

**Specific Contributions**:
- Developed the `align_seqs_fasta` function to process FASTA files with support for command-line input arguments. Implemented default behavior to use sample data files when no input is provided.  
- Reviewed the `align_seqs_better` code and tested it, ensuring it had correct filepaths to both load the data and results.
- Created a `.gitignore` file to exclude unnecessary and temporary files across multiple programming languages.  
- Managed repository maintenance tasks, including file cleanup (e.g., removal of `dummy.txt`) and merging three separate branches into the `main` branch.  
- Contributed to the writing and editing of the `contributions.md` documentation.  

**Key commits**: 

- [`e1a8e86`] (HEAD -> main, origin/main) Updating the gitignore file so that it ignores files inside folders and adding a gitkeep to the results folder. Also cleaned up the repo (removing unnesesary files).
- [`57bb06c`] Merge branch 'Mikael' into main. This included two other branches.  
- [`56cdf09`] Creating the  align sequences to have the ability to input any two files, with default files if none are given.  
- [`7f4f9c8`] Bug testing the align_seqs_better code and changing it so that it works from the /code directory,  instead of the main directory.  

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
- [`bb7091b`] — Updated `JustOaksData.csv` after running `oaks_debugme.py`.  
- [`5b1b7eb`] — Merged branch `daniel` with `main`.  
- [`867dab3`]— Uploaded the `CONTRIBUTIONS.md` template for collaborative editing.

---

### Avery Chen
**Role(s)**: [e.g., Integration specialist, Error handling, Code optimization]

**Specific Contributions**:
- [Describe specific code/functions written]
- [Describe documentation contributions]
- [Describe testing/debugging work]
- [Describe other contributions]

**Key commits**: [List 3-5 most significant commit hashes and brief descriptions]

---
### Hanxiao Wang
**Role(s)**: [e.g., Integration specialist, Error handling, Code optimization]

**Specific Contributions**:
- [Describe specific code/functions written]
- [Describe documentation contributions]
- [Describe testing/debugging work]
- [Describe other contributions]

**Key commits**: [List 3-5 most significant commit hashes and brief descriptions]

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

[Describe the code review process used, e.g., pull request reviews, pair programming sessions]

**Pull Requests**:
- PR #1: [Brief description] - Reviewed by: [names]
- PR #2: [Brief description] - Reviewed by: [names]
- [etc.]

## Testing and Quality Assurance

[Describe testing approaches used and who contributed to testing]

## Declaration

We declare that the above contributions are accurate and that all team members participated actively in this group work.

**Signatures** (or typed names with date):
- [Team Member 1]: _______________  Date: _______
- [Team Member 2]: _______________  Date: _______
- [Team Member 3]: _______________  Date: _______
