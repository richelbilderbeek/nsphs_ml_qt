#!/bin/bash
#
# Do the full flow for experiment one
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/02_start_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/02_start_1.sh
#
# You can without moral concerns run this script without 'sbatch',
# as all it does is 'sbatch'-ing other scripts
#
#SBATCH -A snic2021-22-624
#SBATCH --time=0:05:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=02_start_richel_issue_144
#SBATCH --output=02_start_richel_issue_144.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

n_random_snpses=$(seq 0 10)
pheno_model_ids="p0 p1 p2"
echo "n_random_snpses: {n_random_snpses}"
echo "pheno_model_ids: {pheno_model_ids}"

for n_random_snps in $n_random_snpses; do
  for pheno_model_id in $pheno_model_ids; do 
    unique_id="richel_issue_144_${pheno_model_id}_${n_random_snps}"
    echo "Running with: ${unique_id} ${pheno_model_id} ${n_random_snps}"
    sbatch nsphs_ml_qt/scripts_rackham/03_start_richel_issue_144_run.sh $unique_id $pheno_model_id $n_random_snps
  done
done

echo "End time: $(date --iso-8601=seconds)"


