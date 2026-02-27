#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=2gb
#PBS -N hw2625_neutral

cd "$PBS_O_WORKDIR"

# Try to load an R module if modules are available on this cluster.
if command -v module >/dev/null 2>&1; then
  module load R 2>/dev/null || module load r 2>/dev/null || true
fi

# Resolve Rscript path robustly.
if [ -x "/sw-eb/software/R/4.5.1-gfbf-2025a/bin/Rscript" ]; then
  RSCRIPT_BIN="/sw-eb/software/R/4.5.1-gfbf-2025a/bin/Rscript"
elif command -v Rscript >/dev/null 2>&1; then
  RSCRIPT_BIN="$(command -v Rscript)"
elif [ -x "$HOME/anaconda3/bin/Rscript" ]; then
  RSCRIPT_BIN="$HOME/anaconda3/bin/Rscript"
elif [ -x "$HOME/miniconda3/bin/Rscript" ]; then
  RSCRIPT_BIN="$HOME/miniconda3/bin/Rscript"
else
  echo "ERROR: Rscript not found. Check module names with: module avail 2>&1 | grep -i -E '(^|/)r($|/)'"
  exit 127
fi

"$RSCRIPT_BIN" hw2625_HPC_2025_neutral_cluster.R
