#!/bin/bash
#
# Do the plotting of dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset_1.sh
#
# From the GCAE help:
#
# run_gcae.py plot --datadir=<name> [  --data=<name>  --model_id=<name> --train_opts_id=<name> --data_opts_id=<name>  --superpops=<name> --epoch=<num> --trainedmodeldir=<name>  --pdata=<name> --trainedmodelname=<name>] [--pheno_model_id=<name>]
#


# Works on Rackham
datadir=~/nsphs_ml_qt/inst/extdata
trainedmodeldir=~/sim_data_1_ae/ # Really need that slash at the end

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash at the end
fi

echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"

python3 GenoCAE/run_gcae.py \
  plot \
  --datadir $datadir \
  --data sim_data_1 \
  --trainedmodeldir $trainedmodeldir \
  --model_id M1 \
  --epochs 3 \
  --save_interval 1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --pheno_model_id=p1

