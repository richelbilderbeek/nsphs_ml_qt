#!/bin/bash
#
# Run #45
#
# Usage: 
#
#   sbatch ./nsphs_ml_qt/scripts_rackham/02_start_issue_45.sh
#
#SBATCH -A snic2021-22-624
#SBATCH --time=100:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#SBATCH --job-name=02_start_issue_45
#SBATCH --output=02_start_issue_45.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

if [ ! -f nsphs_ml_qt/nsphs_ml_qt.sif ]; then
  echo "'nsphs_ml_qt/nsphs_ml_qt.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'nsphs_ml_qt' folder:"
  cd nsphs_ml_qt || exit 41
  ls
  cd - || exit 42
  exit 43
fi

singularity run nsphs_ml_qt/nsphs_ml_qt.sif Rscript nsphs_ml_qt/scripts_local/issue_45.R

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

