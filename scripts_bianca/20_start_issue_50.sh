#!/bin/bash
#
# Do the full flow for experiment that GitHub Issue
#
# Usage:
#
#   ./nsphs_ml_qt/scripts_bianca/[this file's name]
#   sbatch ./nsphs_ml_qt/scripts_bianca/[this file's name]
#
# You can without moral concerns run this script without 'sbatch',
# as all it does is 'sbatch'-ing other scripts
#
#SBATCH -A sens2021565
#SBATCH --time=0:05:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#SBATCH --job-name=20_start_issue_50
#SBATCH --output=20_start_issue_50.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"


for window_kb in 1 10 100 1000
do
  echo "window_kb: $window_kb"

  gcae_experiment_params_filename=/proj/sens2021565/nobackup/nsphs_ml_qt_results/data_issue_50_$window_kb/experiment_params.csv
  unique_id=$(echo "$gcae_experiment_params_filename" | grep -E -o "issue_[[:digit:]]+_[[:digit:]]+")
  echo "gcae_experiment_params_filename: ${gcae_experiment_params_filename}"
  echo "unique_id: ${unique_id}"

  jobid_21=$(sbatch -A sens2021565                                              --output=21_create_"${unique_id}"_params.log            ./nsphs_ml_qt/scripts_bianca/21_create_issue_50_params.sh   "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
  jobid_22=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_21"             --output=22_create_"${unique_id}"_data.log              ./nsphs_ml_qt/scripts_bianca/22_create_issue_50_data.sh     "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
  jobid_24=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=24_create_input_data_plots_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/24_create_input_data_plots.sh "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
  jobid_25=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=25_run_"${unique_id}".log                      ./nsphs_ml_qt/scripts_rackham/25_run.sh                     "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
  jobid_26=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=26_assoc_qt_"${unique_id}".log                 ./nsphs_ml_qt/scripts_rackham/26_assoc_qt.sh                "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
  jobid_29=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_25":"$jobid_26" --output=29_zip_"${unique_id}".log                      ./nsphs_ml_qt/scripts_bianca/29_zip.sh                      "$gcae_experiment_params_filename" | cut -d ' ' -f 4)

  echo "jobid_21: ${jobid_21}"
  echo "jobid_22: ${jobid_22}"
  echo "jobid_24: ${jobid_24}"
  echo "jobid_25: ${jobid_25}"
  echo "jobid_26: ${jobid_26}"
  echo "jobid_29: ${jobid_29}"
done

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

