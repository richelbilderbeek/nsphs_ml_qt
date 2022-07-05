#!/bin/bash
#
# Run https://github.com/richelbilderbeek/nsphs_ml_qt/issues/61
#
# Usage: 
#
#   sbatch ./start_issue_61.sh
#
#
#SBATCH -A snic2021-22-624
#SBATCH --time=230:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
#SBATCH --mem=16G
#SBATCH --job-name=issue_61
#SBATCH --output=issue_61.log

echo "base_input_filename: ${base_input_filename}"
echo "n_individuals: ${n_individuals}"
echo "n_traits: ${n_traits}"
echo "n_snps_per_trait: ${n_snps_per_trait}"
echo "singularity_filename: ${singularity_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

singularity run nsphs_ml_qt/nsphs_ml_qt.sif Rscript nsphs_ml_qt/scripts_local/issue_61/issue_61.R

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"


