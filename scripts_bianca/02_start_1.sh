#!/bin/bash
#
# Do the full flow for experiment one
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_bianca/02_start_1.sh
#   sbatch ./nsphs_ml_qt/scripts_bianca/02_start_1.sh
#
# You can without moral concerns run this script without 'sbatch',
# as all it does is 'sbatch'-ing other scripts
#
#SBATCH -A sens2021565
#SBATCH --time=0:05:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=02_start_1
#SBATCH --output=02_start_1.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

jobid_10=$(sbatch                                ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh      | cut -d ' ' -f 4)
jobid_11=$(sbatch --dependency=afterok:$jobid_10 ./nsphs_ml_qt/scripts_bianca/11_train_on_dataset_1.sh    | cut -d ' ' -f 4)
jobid_12=$(sbatch --dependency=afterok:$jobid_11 ./nsphs_ml_qt/scripts_bianca/12_project_on_dataset_1.sh  | cut -d ' ' -f 4)
jobid_13=$(sbatch --dependency=afterok:$jobid_12 ./nsphs_ml_qt/scripts_bianca/13_plot_on_dataset_1.sh     | cut -d ' ' -f 4)
jobid_14=$(sbatch --dependency=afterok:$jobid_13 ./nsphs_ml_qt/scripts_bianca/14_animate_on_dataset_1.sh  | cut -d ' ' -f 4)
jobid_15=$(sbatch --dependency=afterok:$jobid_14 ./nsphs_ml_qt/scripts_bianca/15_evaluate_on_dataset_1.sh | cut -d ' ' -f 4)

echo "End time: $(date --iso-8601=seconds)"

