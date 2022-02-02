#!/bin/bash
#
# Do the plotting of dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset_1.sh
#
# From the GCAE help:
#
# run_gcae.py animate --datadir=<name>   [ --data=<name>   --model_id=<name> --train_opts_id=<name> --data_opts_id=<name>  --superpops=<name> --epoch=<num> --trainedmodeldir=<name> --pdata=<name> --trainedmodelname=<name>]
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
#SBATCH --job-name=14_animate_on_dataset_1
#SBATCH --output=14_animate_on_dataset_1.log

echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

# Error: File /home/richel/sim_data_1_ae/ae.M1.ex3.b_0_4.sim_data_1/sim_data_1/encoded_data.h5 not found
echo "Will not run this script, as this will return in an error"
exit 0


datadir=~/nsphs_ml_qt/inst/extdata
trainedmodeldir=~/sim_data_1_ae/ # Really need that slash at the end
superpops=~/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash at the end
  superpops=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv
fi

if [ ! -f $superpops ]; then
  echo "'superpops' file not found at path $superpops"
  exit 42
fi

echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: $superpops"

# --pdata=<name>

python3 GenoCAE/run_gcae.py \
  animate \
  --datadir $datadir \
  --data sim_data_1 \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --superpops $superpops \
  --epoch 3 \
  --trainedmodeldir $trainedmodeldir
