#!/bin/bash
#
# Do a projection on dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/12_project_on_dataset_1.sh
#
# From the GCAE help:
#
# run_gcae.py project --datadir=<name>   [ --data=<name> --model_id=<name>  --train_opts_id=<name> --data_opts_id=<name> --superpops=<name> --epoch=<num> --trainedmodeldir=<name>   --pdata=<name> --trainedmodelname=<name>] [--pheno_model_id=<name>]
#


# Works on Rackham
datadir=~/nsphs_ml_qt/inst/extdata
trainedmodeldir=~/sim_data_1_ae/ # Really need that slash
superpops=~/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/
  superpops=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv

  echo "Show 'sim_data_1.fam':"
  head /home/richel/GitHubs/nsphs_ml_qt/inst/extdata/sim_data_1.fam

  echo "Show 'superpops' file:"
  head $superpops
fi

echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: $superpops"

if [ ! -f $superpops ]; then
  echo "'superpops' file not found at path $superpops"
  exit 42
fi

python3 GenoCAE/run_gcae.py \
  project \
  --datadir $datadir \
  --data sim_data_1 \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --superpops $superpops \
  --epoch 3 \
  --trainedmodeldir $trainedmodeldir \
  --pheno_model_id=p1

