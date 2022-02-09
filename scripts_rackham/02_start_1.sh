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
#SBATCH --job-name=02_start_1
#SBATCH --output=02_start_1.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

# Original first sim setting
#base_input_filename=nsphs_ml_qt/inst/extdata/sim_data_1
#n_individuals=1000
#n_traits=1
#n_snps_per_trait=1

base_input_filename=nsphs_ml_qt/inst/extdata/sim_data_2
n_individuals=500
n_traits=40
n_snps_per_trait=30

datadir=~/nsphs_ml_qt/inst/extdata/ # Really need that slash
trainedmodeldir=~/sim_data_1_ae/ # Really need that slash
epochs=100
epoch=$epochs
save_interval=$epochs

echo "base_input_filename: $base_input_filename"
echo "n_individuals: $n_individuals"
echo "n_traits: $n_traits"
echo "n_snps_per_trait: $n_snps_per_trait"
echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "epochs: $epochs"
echo "epoch: $epoch"
echo "save_interval: $save_interval"

jobid_10=$(sbatch                                ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh $base_input_filename $n_individuals $n_traits $n_snps_per_trait | cut -d ' ' -f 4)
jobid_11=$(sbatch --dependency=afterok:$jobid_10 ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh    | cut -d ' ' -f 4)
jobid_12=$(sbatch --dependency=afterok:$jobid_11 ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset_1.sh  | cut -d ' ' -f 4)
jobid_13=$(sbatch --dependency=afterok:$jobid_12 ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset_1.sh     | cut -d ' ' -f 4)
jobid_14=$(sbatch --dependency=afterok:$jobid_13 ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset_1.sh  | cut -d ' ' -f 4)
jobid_15=$(sbatch --dependency=afterok:$jobid_14 ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset_1.sh | cut -d ' ' -f 4)

echo "End time: $(date --iso-8601=seconds)"

