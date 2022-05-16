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

for autoenoder_model in M0_1n M0_2n M0_3n M0_4n M0_5n M0 M1_1n M1_2n M1_3n M1_4n M1_5n M1 M3d_1n M3d_2n M3d_3n M3d_4n M3d_5n M3d M3e_1n M3e_2n M3e_3n M3e_4n M3e_5n M3e M3f_1n M3f_2n M3f_3n M3f_4n M3f_5n M3f M3j10U_1n M3j10U_2n M3j10U_3n M3j10U_4n M3j10U_5n M3j10U M3j10X_1n M3j10X_2n M3j10X_3n M3j10X_4n M3j10X_5n M3j10X 
do
  for phenotype_prediction_model in p0 p1 p2
  do
    for window_kb in 1 10 100 1000
    do
      echo "autoenoder_model: $autoenoder_model"
      echo "phenotype_prediction_model: $phenotype_prediction_model"
      echo "window_kb: $window_kb"

      unique_id="issue_42_${autoenoder_model}_${phenotype_prediction_model}_${window_kb}"
      echo "unique_id: ${unique_id}"

      gcae_experiment_params_filename=~/data_${unique_id}/experiment_params.csv
      echo "gcae_experiment_params_filename: ${gcae_experiment_params_filename}"

      jobid_21=$(sbatch -A sens2021565                                              --output=21_create_"${unique_id}"_params.log ./nsphs_ml_qt/scripts_bianca/21_create_issue_42_params.sh              "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_22=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_21"             --output=22_create_"${unique_id}"_data.log   ./nsphs_ml_qt/scripts_bianca/22_create_issue_29_data.sh                "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_24=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=24_create_input_data_plots_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/24_create_input_data_plots.sh "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_25=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=25_run_"${unique_id}".log           ./nsphs_ml_qt/scripts_rackham/25_run.sh                                "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_26=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_22"             --output=26_assoc_qt_"${unique_id}".log      ./nsphs_ml_qt/scripts_rackham/26_assoc_qt.sh                           "$gcae_experiment_params_filename" | cut -d ' ' -f 4)
      jobid_29=$(sbatch -A sens2021565 --dependency=afterok:"$jobid_25":"$jobid_26" --output=29_zip_"${unique_id}".log           ./nsphs_ml_qt/scripts_bianca/29_zip.sh                                 "$gcae_experiment_params_filename" | cut -d ' ' -f 4)

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
