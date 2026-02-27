#!/bin/bash
#PBS -l walltime=00:10:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -N hw2625_demo

# Move to the directory where the script was submitted
cd "$PBS_O_WORKDIR"

# Try to load an R module if modules are available on this cluster.
if command -v module >/dev/null 2>&1; then
  module load R 2>/dev/null || module load r 2>/dev/null || true
fi

# Resolve Rscript path robustly.
if [ -x "/sw-eb/software/R/4.5.1-gfbf-2025a/bin/Rscript" ]; then
  RSCRIPT_BIN="/sw-eb/software/R/4.5.1-gfbf-2025a/bin/Rscript"
else
  echo "ERROR: Rscript not found. Check module names with: module avail 2>&1 | grep -i -E '(^|/)r($|/)'"
  exit 127
fi

# Run the R script
"$RSCRIPT_BIN" hw2625_HPC_2025_demographic_cluster.R
