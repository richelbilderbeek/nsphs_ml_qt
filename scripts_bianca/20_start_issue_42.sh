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
#SBATCH --job-name=20_start_issue_42
#SBATCH --output=20_start_issue_42.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

# M3j10U M3j10X are not compatible
for autoenoder_model in M1 M3d M3e M3f
do
  for phenotype_prediction_model in p1 p2
  do
    for window_kb in 1 10 100 1000
    do
      echo "autoenoder_model: $autoenoder_model"
      echo "phenotype_prediction_model: $phenotype_prediction_model"
      echo "window_kb: $window_kb"

      unique_id="issue_42_${autoenoder_model}_${phenotype_prediction_model}_${window_kb}"
      echo "unique_id: ${unique_id}"

      gcae_experiment_params_filename=/proj/sens2021565/nobackup/nsphs_ml_qt_results/data_${unique_id}/experiment_params.csv
      echo "gcae_experiment_params_filename: ${gcae_experiment_params_filename}"

      jobid_21=$(sbatch -A sens2021565                                              --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/21_create_"${unique_id}"_params.log ./nsphs_ml_qt/scripts_bianca/21_create_issue_42_params.sh              "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_22=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_21"             --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/22_create_"${unique_id}"_data.log   ./nsphs_ml_qt/scripts_bianca/22_create_issue_42_data.sh                "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_24=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/24_create_input_data_plots_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/24_create_input_data_plots.sh "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_25=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/25_run_"${unique_id}".log           ./nsphs_ml_qt/scripts_rackham/25_run.sh                                "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_26=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/26_assoc_qt_"${unique_id}".log      ./nsphs_ml_qt/scripts_rackham/26_assoc_qt.sh                           "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_29=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_25":"$jobid_26" --output=/proj/sens2021565/nobackup/nsphs_ml_qt_results/29_zip_"${unique_id}".log           ./nsphs_ml_qt/scripts_bianca/29_zip.sh                                 "$gcae_experiment_params_filename" | cut -d ' ' -f 4)

      echo "jobid_21: ${jobid_21}"
      echo "jobid_22: ${jobid_22}"
      echo "jobid_24: ${jobid_24}"
      echo "jobid_25: ${jobid_25}"
      echo "jobid_26: ${jobid_26}"
      echo "jobid_29: ${jobid_29}"
    done
  done
done

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"
