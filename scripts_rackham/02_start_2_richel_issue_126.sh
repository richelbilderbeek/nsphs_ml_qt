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
#SBATCH --job-name=02_start_2_richel_issue_126
#SBATCH --output=02_start_2_richel_issue_126-%j.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

datadir=~/sim_data_2_richel_issue_126/ # Really need that slash
data=sim_data_2_richel_issue_126
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"
n_individuals=1000
n_random_snps=0

trainedmodeldir=~/sim_data_1_ae/ # Really need that slash
epochs=1000
epoch=$epochs
save_interval=100
metrics="hull_error,f1_score_3"

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "superpops: ${superpops}"
echo "n_individuals: ${n_individuals}"
echo "n_random_snps: ${n_random_snps}"
echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "epochs: $epochs"
echo "epoch: $epoch"
echo "save_interval: $save_interval"
echo "metrics: $metrics"

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

jobid_10=$(sbatch -A snic2021-22-624                                ./nsphs_ml_qt/scripts_rackham/10_create_dataset_2.sh $base_input_filename $n_individuals $n_random_snps            | cut -d ' ' -f 4)
jobid_11=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_10 ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh $datadir $data $trainedmodeldir $epochs $save_interval        | cut -d ' ' -f 4)
jobid_12=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_11 ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch           | cut -d ' ' -f 4)
jobid_13=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_12 ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch              | cut -d ' ' -f 4)
jobid_14=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_13 ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                             | cut -d ' ' -f 4)
jobid_15=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_14 ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir $superpops $metrics $epoch | cut -d ' ' -f 4)

echo "End time: $(date --iso-8601=seconds)"

