#!/bin/bash
#
# Do the full flow for Issue 18
#
# Usage:
#
#   ./nsphs_ml_qt/scripts_local/20_start_issue_18.sh
#
#
#SBATCH -A snic2021-22-624
#SBATCH --time=0:05:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#SBATCH --job-name=20_start_issue_18
#SBATCH --output=20_start_issue_18.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

if [ ! -f gcae/gcae.sif ]; then
  echo "'gcae/gcae.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'gcae' folder:"
  cd gcae ; ls ; cd -
  exit 42
fi
if [ ! -f gcaer/gcaer.sif ]; then
  echo "'gcaer/gcaer.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'gcaer' folder:"
  cd gcaer ; ls ; cd -
  exit 42
fi

gcae_experiment_params_filename=~/sim_data_issue_18/experiment_params.csv

unique_id=$(echo $gcae_experiment_params_filename | egrep -o "issue_[[:digit:]]+")
echo "gcae_experiment_params_filename: ${gcae_experiment_params_filename}"
echo "unique_id: ${unique_id}"

./nsphs_ml_qt/scripts_rackham/21_create_issue_18_data.sh $gcae_experiment_params_filename
./nsphs_ml_qt/scripts_rackham/25_run.sh                  $gcae_experiment_params_filename
./nsphs_ml_qt/scripts_rackham/28_analyse.sh              $gcae_experiment_params_filename
./nsphs_ml_qt/scripts_rackham/29_zip.sh                  $gcae_experiment_params_filename

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"
