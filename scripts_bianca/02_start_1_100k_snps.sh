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
#SBATCH --output=02_start_1-%j.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"


datadir=~/data_1/ # Really need that slash
data=data_1
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"
trainedmodeldir=~/data_1_ae/ # Really need that slash
thin_count=100000 # Number of SNPs that remain
epochs=200
epoch=$epochs
save_interval=10
metrics="hull_error,f1_score_3"

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "superpops: ${superpops}"
echo "trainedmodeldir: ${trainedmodeldir}"
echo "thin_count: ${thin_count}"
echo "epochs: ${epochs}"
echo "epoch: ${epoch}"
echo "save_interval: ${save_interval}"
echo "metrics: ${metrics}"

jobid_10=$(sbatch -A sens2021565                                ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh $datadir $data $base_input_filename $superpops $thin_count        | cut -d ' ' -f 4)
jobid_11=$(sbatch -A sens2021565 --dependency=afterok:$jobid_10 ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh $datadir $data $trainedmodeldir $epochs $save_interval           | cut -d ' ' -f 4)
jobid_12=$(sbatch -A sens2021565 --dependency=afterok:$jobid_11 ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch              | cut -d ' ' -f 4)
jobid_13=$(sbatch -A sens2021565 --dependency=afterok:$jobid_12 ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch                 | cut -d ' ' -f 4)
jobid_14=$(sbatch -A sens2021565 --dependency=afterok:$jobid_13 ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                                | cut -d ' ' -f 4)
jobid_15=$(sbatch -A sens2021565 --dependency=afterok:$jobid_14 ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir $superpops $metrics $epoch    | cut -d ' ' -f 4)
jobid_16=$(sbatch -A sens2021565 --dependency=afterok:$jobid_15 ./nsphs_ml_qt/scripts_bianca/16_create_tidy_results.sh                                                                | cut -d ' ' -f 4)
jobid_17=$(sbatch -A sens2021565 --dependency=afterok:$jobid_16 ./nsphs_ml_qt/scripts_bianca/17_zip_depersonalized_data.sh $datadir $data $trainedmodeldir $superpops $metrics $epoch | cut -d ' ' -f 4)

echo "End time: $(date --iso-8601=seconds)"
