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
#SBATCH -A snic2021-22-624
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
#SBATCH --output=10_create_dataset_1.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

if [[ $HOSTNAME =~ ^r[0-9]{1-3}$ ]] ; then
  echo "Running on Rackham runner node"
  # No need to load modules here
  # module load python/3.8.7
fi

if [ ! -z $GITHUB_ACTIONS ]; then 
  echo "Running on GitHub Actions"
  # No need to load modules here
  # module load python/3.8.7
fi


Rscript nsphs_ml_qt/scripts_rackham/10_create_dataset_1.R

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

if [[ $HOSTNAME =~ "^r[0-9]{1-3}$" ]] ; then
  echo "Showing jobstats"
  jobstats -A snic2021-22-624 -p %j 
fi

