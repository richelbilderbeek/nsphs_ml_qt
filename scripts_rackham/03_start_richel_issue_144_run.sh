#!/bin/bash
#
# Do one run for Issue 144
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
#SBATCH --job-name=02_start_richel_issue_144
#SBATCH --output=02_start_richel_issue_144.log

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

echo "Parameters: $*"
echo "Number of parameters: $#"

if [[ "$#" -ne 3 ]] ; then
  echo "Invalid number of arguments: must have 3 parameters: "
  echo " "
  echo "  1. unique_id"
  echo "  2. pheno_model_id"
  echo "  3. n_random_snps"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi


echo "Correct number of arguments: $#"
unique_id=$1
pheno_model_id=$2
n_random_snps=$3
echo "unique_id: ${unique_id}"
echo "pheno_model_id: ${pheno_model_id}"
echo "n_random_snps: ${n_random_snps}"

datadir=~/sim_data_${unique_id}/ # Really need that slash
data="sim_data_${unique_id}"
trainedmodeldir=~/sim_data_"${unique_id}"_ae/ # Really need that slash
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"
n_individuals=1000

epochs=1000
epoch=$epochs
save_interval=100
metrics="hull_error,f1_score_3"

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: ${superpops}"
echo "n_individuals: ${n_individuals}"
echo "n_random_snps: ${n_random_snps}"
echo "datadir: $datadir"
echo "epochs: $epochs"
echo "epoch: $epoch"
echo "save_interval: $save_interval"
echo "metrics: $metrics"

if [ ! -f gcae/gcae.sif ]; then
  echo "'gcae/gcae.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'gcae' folder:"
  cd nsphs_ml_qt || exit 41
  ls
  cd -
  exit 42
fi
if [ ! -f nsphs_ml_qt/nsphs_ml_qt.sif ]; then
  echo "'nsphs_ml_qt/nsphs_ml_qt.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'nsphs_ml_qt' folder:"
  cd nsphs_ml_qt ; ls ; cd -
  exit 42
fi

jobid_16=$(sbatch -A snic2021-22-624                                --output=16_analyse_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir "$unique_id"                                       | cut -d ' ' -f 4)
jobid_17=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_16" --output=17_zip_"${unique_id}".log      ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh         $datadir $trainedmodeldir "$unique_id"                                       | cut -d ' ' -f 4)

#jobid_10=$(sbatch -A snic2021-22-624                                --output=10_create_"${unique_id}".log   ./nsphs_ml_qt/scripts_rackham/10_create_dataset_2.sh "$base_input_filename" $n_individuals "$n_random_snps"                            | cut -d ' ' -f 4)
#jobid_11=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_10" --output=11_train_"${unique_id}".log    ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh $datadir $data $trainedmodeldir $epochs $save_interval "$pheno_model_id"        | cut -d ' ' -f 4)
#jobid_12=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_11" --output=12_project_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh $datadir $data $trainedmodeldir "$superpops" "$epoch" "$pheno_model_id"           | cut -d ' ' -f 4)
#jobid_13=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_12" --output=13_plot_"${unique_id}".log     ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh $datadir $data $trainedmodeldir "$superpops" "$epoch" "$pheno_model_id"              | cut -d ' ' -f 4)
#jobid_14=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_13" --output=14_animate_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                                             | cut -d ' ' -f 4)
#jobid_15=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_14" --output=15_evaluate_"${unique_id}".log ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir "$superpops" $metrics "$epoch" "$pheno_model_id" | cut -d ' ' -f 4)
#jobid_16=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_15" --output=16_analyse_"${unique_id}".log  ./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir "$unique_id"                                       | cut -d ' ' -f 4)
#jobid_17=$(sbatch -A snic2021-22-624 --dependency=afterok:"$jobid_16" --output=17_zip_"${unique_id}".log      ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh         $datadir $trainedmodeldir "$unique_id"                                       | cut -d ' ' -f 4)

#echo "jobid_10: ${jobid_10}"
#echo "jobid_11: ${jobid_11}"
#echo "jobid_12: ${jobid_12}"
#echo "jobid_13: ${jobid_13}"
#echo "jobid_14: ${jobid_14}"
#echo "jobid_15: ${jobid_15}"
echo "jobid_16: ${jobid_16}"
echo "jobid_17: ${jobid_17}"

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"


