
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
align_seqs_fasta.py
-------------------
Align two DNA sequences by sliding the shorter across the longer and scoring matches.
Records *all* equally-best alignments, saves a human-readable report and a pickle file.

Usage:
    python3 align_seqs_fasta.py seq1.fasta seq2.fasta
If no paths are provided, the script will try ./data/seq1.fasta and ./data/seq2.fasta.
If those are missing, it falls back to two built-in example sequences so it still runs.

Outputs (created under ./results/):
    - alignment_results.txt : human-readable summary
    - alignment_results.pkl : python pickle with the full results dict

This implementation follows the classic MulQuaBio "Align DNA sequences" practical.
"""

import argparse
import os
import pickle
from typing import List, Dict, Tuple

# ---------------------------
# FASTA utilities
# ---------------------------

def read_fasta(path: str) -> Tuple[str, str]:
    """Read a (single-sequence) FASTA file and return (header, sequence in uppercase)."""
    if not os.path.exists(path):
        raise FileNotFoundError(f"FASTA not found: {path}")
    header = None
    seq_parts: List[str] = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith('>'):
                # Keep the first header, ignore subsequent ones for simplicity
                if header is None:
                    header = line[1:].strip()
            else:
                seq_parts.append(line.upper())
    seq = ''.join(seq_parts)
    if header is None:
        header = os.path.basename(path)
    return header, seq

def sanitize_dna(seq: str) -> str:
    """Uppercase and keep only A/C/G/T/N; remove others (spaces, numbers, etc.)."""
    seq = seq.upper()
    allowed = {'A', 'C', 'G', 'T', 'N'}
    return ''.join(ch for ch in seq if ch in allowed)

# ---------------------------
# Alignment core
# ---------------------------

def calculate_score(s1: str, s2: str, startpoint: int) -> int:
    """Return the number of matching bases when s2 is aligned to s1 at startpoint."""
    score = 0
    l1 = len(s1)
    l2 = len(s2)
    for i in range(l2):
        pos_in_s1 = startpoint + i
        if pos_in_s1 >= l1:
            break  # s2 hangs off the end of s1
        if s1[pos_in_s1] == s2[i]:
            score += 1
    return score

def align_sequences(raw_s1: str, raw_s2: str) -> Dict:
    """Align two sequences, returning a dict with best score and all equally-best alignments."""
    # Ensure we slide the *shorter* across the *longer*
    s1 = sanitize_dna(raw_s1)
    s2 = sanitize_dna(raw_s2)
    if len(s1) < len(s2):
        s1, s2 = s2, s1  # swap so s1 is the longer
    
    best_score = -1
    best_alignments: List[Dict] = []
    l1 = len(s1)
    l2 = len(s2)

    for start in range(0, l1):  # try all start positions on s1
        sc = calculate_score(s1, s2, start)
        if sc > best_score:
            best_score = sc
            best_alignments = [{
                'start': start,
                'aligned_s2': ('.' * start) + s2,
            }]
        elif sc == best_score:
            best_alignments.append({
                'start': start,
                'aligned_s2': ('.' * start) + s2,
            })

    return {
        's1': s1,
        's2': s2,
        'best_score': best_score,
        'best_alignments': best_alignments,
    }

# ---------------------------
# I/O helpers
# ---------------------------

def ensure_dir(path: str) -> None:
    os.makedirs(path, exist_ok=True)

def save_results(results: Dict, out_dir: str = 'results') -> Tuple[str, str]:
    """Save results as text and pickle in out_dir. Return (txt_path, pkl_path)."""
    ensure_dir(out_dir)
    txt_path = os.path.join(out_dir, 'alignment_results.txt')
    pkl_path = os.path.join(out_dir, 'alignment_results.pkl')

    s1 = results['s1']
    s2 = results['s2']
    best_score = results['best_score']
    best_alignments = results['best_alignments']

    # Human-readable report
    with open(txt_path, 'w', encoding='utf-8') as f:
        f.write('== DNA Alignment Results ==\n\n')
        f.write(f'Length(s): s1={len(s1)}, s2={len(s2)}\n')
        f.write(f'Best score: {best_score}\n')
        f.write(f'Number of equally-best alignments: {len(best_alignments)}\n\n')

        # Show the base sequences
        f.write('S1 (reference):\n')
        f.write(s1 + '\n\n')
        f.write('S2 (query):\n')
        f.write(s2 + '\n\n')

        f.write('--- Best alignments (all ties) ---\n')
        for i, aln in enumerate(best_alignments, 1):
            f.write(f'[{i}] start={aln["start"]}\n')
            f.write(aln['aligned_s2'] + '\n\n')

    # Pickle everything
    with open(pkl_path, 'wb') as pf:
        pickle.dump(results, pf)

    return txt_path, pkl_path

# ---------------------------
# Defaults & CLI
# ---------------------------

DEFAULTS = (
    os.path.join('..', 'data', '407228326.fasta'),
    os.path.join('..', 'data', '407228412.fasta'),
)

BUILTIN_EXAMPLE = (
    '>Example_seq_1\nGATTACAAGGTTAC\n',
    '>Example_seq_2\nTTACAGTTAC\n',
)

def main():
    parser = argparse.ArgumentParser(description='Align two DNA FASTA sequences and record all best alignments.')
    parser.add_argument('fasta1', nargs='?', help='Path to first FASTA file')
    parser.add_argument('fasta2', nargs='?', help='Path to second FASTA file')
    parser.add_argument('-o', '--outdir', default='../results', help='Output directory (default: ../results)')
    args = parser.parse_args()

    # Determine input sources
    candidates = []
    if args.fasta1 and args.fasta2:
        candidates = [args.fasta1, args.fasta2]
    else:
        candidates = list(DEFAULTS)

    try:
        if all(os.path.exists(p) for p in candidates):
            h1, s1 = read_fasta(candidates[0])
            h2, s2 = read_fasta(candidates[1])
        else:
            # fall back to built-in example sequences so the script still runs
            h1, s1 = 'Builtin_1', sanitize_dna(BUILTIN_EXAMPLE[0].split('\n', 1)[1])
            h2, s2 = 'Builtin_2', sanitize_dna(BUILTIN_EXAMPLE[1].split('\n', 1)[1])
    except Exception as e:
        print(f'[ERROR] Failed to read FASTA inputs: {e}')
        print('Falling back to built-in example sequences.')
        h1, s1 = 'Builtin_1', sanitize_dna(BUILTIN_EXAMPLE[0].split('\n', 1)[1])
        h2, s2 = 'Builtin_2', sanitize_dna(BUILTIN_EXAMPLE[1].split('\n', 1)[1])

    results = align_sequences(s1, s2)
    results['header1'] = h1
    results['header2'] = h2

    txt_path, pkl_path = save_results(results, args.outdir)
    print('Done.')
    print(f'Best score: {results["best_score"]} | #best alignments: {len(results["best_alignments"]) }')
    print(f'Report   : {txt_path}')
    print(f'Pickle   : {pkl_path}')

if __name__ == '__main__':
    main()


