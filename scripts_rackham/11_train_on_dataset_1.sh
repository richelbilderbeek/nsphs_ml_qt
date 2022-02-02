#!/bin/bash
#
# Create simulated dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
#
#

# Works on Rackham
datadir=~/nsphs_ml_qt/inst/extdata/

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/
fi

echo "datadir: $datadir"

python3 GenoCAE/run_gcae.py \
  train \
  --datadir $datadir \
  --data sim_data_1 \
  --trainedmodeldir sim_data_1_ae/ \
  --model_id M1 \
  --epochs 3 \
  --save_interval 1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --pheno_model_id=p1

