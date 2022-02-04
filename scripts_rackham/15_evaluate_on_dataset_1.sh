#!/bin/bash
#
# Do the evaluation of dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset_1.sh
#
# From the GCAE help:
#
# run_gcae.py evaluate --datadir=<name> --metrics=<name>  [  --data=<name>  --model_id=<name> --train_opts_id=<name> --data_opts_id=<name>  --superpops=<name> --epoch=<num> --trainedmodeldir=<name>  --pdata=<name> --trainedmodelname=<name>] [--pheno_model_id=<name>]
#
#SBATCH -A snic2021-22-624
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=15_evaluate_on_dataset_1
#SBATCH --output=15_evaluate_on_dataset_1.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

datadir=~/nsphs_ml_qt/inst/extdata/ # Really need that slash
trainedmodeldir=~/sim_data_1_ae/ # Really need that slash at the end
superpops=~/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv
metrics="hull_error,f1_score_3"
epoch=100

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash at the end
  superpops=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv
  epoch=3
fi

if [ ! -f $superpops ]; then
  echo "'superpops' file not found at path $superpops"
  exit 42
fi

echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: $superpops"
echo "metrics: $metrics"
echo "epoch: $epoch"

module load python/3.8.7

python3 GenoCAE/run_gcae.py \
  evaluate \
  --datadir $datadir \
  --metrics $metrics \
  --data sim_data_1 \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --superpops $superpops \
  --epoch $epoch \
  --trainedmodeldir $trainedmodeldir \
  --pheno_model_id=p1

echo "End time: $(date --iso-8601=seconds)"

