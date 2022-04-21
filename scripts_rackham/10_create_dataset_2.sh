#!/bin/bash
#
# Create simulated dataset 2 for
# https://github.com/AJResearchGroup/richel/issues/127
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
#SBATCH --job-name=10_create_dataset_2
#Log filename: 10_create_dataset_2.log

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 3 ]] ; then
  echo "Invalid number of arguments: must have 3 parameters: "
  echo " "
  echo "  1. base_input_filename"
  echo "  2. n_individuals"
  echo "  3. n_random_snps"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi

echo "Correct number of arguments: $#"
base_input_filename=$1
n_individuals=$2
n_random_snps=$3
singularity_filename=nsphs_ml_qt.sif

echo "base_input_filename: $base_input_filename"
echo "n_individuals: ${n_individuals}"
echo "n_random_snps: ${n_random_snps}"
echo "singularity_filename: ${singularity_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

singularity run $singularity_filename nsphs_ml_qt/scripts_rackham/10_create_dataset_2.R $base_input_filename $n_individuals $n_random_snps

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"


