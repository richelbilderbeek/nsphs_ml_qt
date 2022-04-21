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
#SBATCH -C usage_mail
#SBATCH --mem=16G
#SBATCH --job-name=02_start_issue_5
#SBATCH --output=02_start_issue_5.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

unique_id=issue_5
datadir=~/data_${unique_id}/ # Really need that slash
data="data_${unique_id}"
trainedmodeldir=~/data_${unique_id}_ae/ # Really need that slash
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"
thin_count=1000 # Number of SNPs that remain
epochs=200
epoch=$epochs
save_interval=10
pheno_model_id="p1"
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
echo "pheno_model_id: ${pheno_model_id}"
echo "metrics: ${metrics}"

jobid_10=$(sbatch -A sens2021565                                --output=10_create_${unique_id}.log   ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh $datadir $data $base_input_filename $superpops $thin_count                     | cut -d ' ' -f 4)
jobid_11=$(sbatch -A sens2021565 --dependency=afterok:$jobid_10 --output=11_train_${unique_id}.log    ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh $datadir $data $trainedmodeldir $epochs $save_interval $pheno_model_id        | cut -d ' ' -f 4)
jobid_12=$(sbatch -A sens2021565 --dependency=afterok:$jobid_11 --output=12_project_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id           | cut -d ' ' -f 4)
jobid_13=$(sbatch -A sens2021565 --dependency=afterok:$jobid_12 --output=13_plot_${unique_id}.log     ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id              | cut -d ' ' -f 4)
jobid_14=$(sbatch -A sens2021565 --dependency=afterok:$jobid_13 --output=14_animate_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                                             | cut -d ' ' -f 4)
jobid_15=$(sbatch -A sens2021565 --dependency=afterok:$jobid_14 --output=15_evaluate_${unique_id}.log ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir $superpops $metrics $epoch $pheno_model_id | cut -d ' ' -f 4)
jobid_16=$(sbatch -A sens2021565 --dependency=afterok:$jobid_15 --output=16_analyse_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir $unique_id                                        | cut -d ' ' -f 4)
jobid_17=$(sbatch -A sens2021565 --dependency=afterok:$jobid_16 --output=17_zip_${unique_id}.log      ./nsphs_ml_qt/scripts_bianca/17_zip_depersonalized_results.sh $trainedmodeldir $unique_id                                          | cut -d ' ' -f 4)

echo "jobid_10: ${jobid_10}"
echo "jobid_11: ${jobid_11}"
echo "jobid_12: ${jobid_12}"
echo "jobid_13: ${jobid_13}"
echo "jobid_14: ${jobid_14}"
echo "jobid_15: ${jobid_15}"
echo "jobid_16: ${jobid_16}"
echo "jobid_17: ${jobid_17}"

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

