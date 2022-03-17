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

unique_id=richel_issue_106
datadir=~/sim_data_1_${unique_id}/ # Really need that slash
data="sim_data_1_${unique_id}"
trainedmodeldir=~/sim_data_1_${unique_id}_ae/ # Really need that slash
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"
n_individuals=1000
n_traits=1
n_snps_per_trait=1000

epochs=200
epoch=$epochs
save_interval=10
pheno_model_id="p1"
metrics="hull_error,f1_score_3"

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "superpops: ${superpops}"
echo "n_individuals: $n_individuals"
echo "n_traits: $n_traits"
echo "n_snps_per_trait: $n_snps_per_trait"
echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "epochs: $epochs"
echo "epoch: $epoch"
echo "save_interval: ${save_interval}"
echo "pheno_model_id: ${pheno_model_id}"
echo "metrics: ${metrics}"

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

jobid_16=$(sbatch -A snic2021-22-624                                --output=16_analyse_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir $unique_id                                       | cut -d ' ' -f 4)
jobid_17=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_16 --output=17_zip_${unique_id}.log      ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh         $datadir $trainedmodeldir $unique_id                                       | cut -d ' ' -f 4)

#jobid_10=$(sbatch -A snic2021-22-624                                --output=10_create_${unique_id}.log   ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh $base_input_filename $n_individuals $n_traits $n_snps_per_trait               | cut -d ' ' -f 4)
#jobid_11=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_10 --output=11_train_${unique_id}.log    ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh $datadir $data $trainedmodeldir $epochs $save_interval $pheno_model_id        | cut -d ' ' -f 4)
#jobid_12=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_11 --output=12_project_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id           | cut -d ' ' -f 4)
#jobid_13=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_12 --output=13_plot_${unique_id}.log     ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id              | cut -d ' ' -f 4)
#jobid_14=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_13 --output=14_animate_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                                             | cut -d ' ' -f 4)
#jobid_15=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_14 --output=15_evaluate_${unique_id}.log ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir $superpops $metrics $epoch $pheno_model_id | cut -d ' ' -f 4)
#jobid_16=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_15 --output=16_analyse_${unique_id}.log  ./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir $unique_id                                       | cut -d ' ' -f 4)
#jobid_17=$(sbatch -A snic2021-22-624 --dependency=afterok:$jobid_16 --output=17_zip_${unique_id}.log      ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh         $datadir $trainedmodeldir $unique_id                                       | cut -d ' ' -f 4)

#echo "jobid_10: ${jobid_10}"
#echo "jobid_11: ${jobid_11}"
#echo "jobid_12: ${jobid_12}"
#echo "jobid_13: ${jobid_13}"
#echo "jobid_14: ${jobid_14}"
#echo "jobid_15: ${jobid_15}"
echo "jobid_16: ${jobid_16}"
echo "jobid_17: ${jobid_17}"

echo "End time: $(date --iso-8601=seconds)"

