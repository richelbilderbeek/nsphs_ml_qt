#!/bin/bash
#
# Create simulated dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
#
#
## No 'SBATCH -A snic2021-22-624', as this is a general script
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=10_create_dataset_1
#Log flename: 10_create_dataset_1.log

# job | memory_used (GH)
# ----+--------------------
# 615 | 1.91


echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 4 ]] ; then
  echo "Invalid number of arguments: must have 4 parameters: "
  echo " "
  echo "  1. base_input_filename"
  echo "  2. n_individuals"
  echo "  3. n_traits"
  echo "  4. n_snps_per_trait"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi

echo "Correct number of arguments: $#"
base_input_filename=$1
n_individuals=$2
n_traits=$3
n_snps_per_trait=$4
singularity_filename=nsphs_ml_qt/nsphs_ml_qt.sif

echo "base_input_filename: ${base_input_filename}"
echo "n_individuals: ${n_individuals}"
echo "n_traits: ${n_traits}"
echo "n_snps_per_trait: ${n_snps_per_trait}"
echo "singularity_filename: ${singularity_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

if echo "$HOSTNAME" | grep -E -q "^r[[:digit:]]{1,3}$"; then
  echo "bash: running on Rackham runner node"
fi

if [ ! -z $GITHUB_ACTIONS ]; then 
  echo "Running on GitHub Actions"
fi


singularity run $singularity_filename nsphs_ml_qt/scripts_rackham/10_create_dataset_1.R $base_input_filename $n_individuals $n_traits $n_snps_per_trait

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"


