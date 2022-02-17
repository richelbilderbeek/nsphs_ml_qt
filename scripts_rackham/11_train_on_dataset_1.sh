#!/bin/bash
#
# Train on dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
#
# From the GCAE help:
#
#   run_gcae.py train --datadir=<name> --data=<name> --model_id=<name> --train_opts_id=<name> --data_opts_id=<name> --save_interval=<num> --epochs=<num> [--resume_from=<num> --trainedmodeldir=<name> ] [--pheno_model_id=<name>]
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
#SBATCH --job-name=11_train_on_dataset_1
#SBATCH --output=11_train_on_dataset_1.log

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 4 ]] ; then
  echo "Invalid number of arguments: must have 4 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. trainedmodeldir"
  echo "  3. epochs"
  echo "  4. save_interval"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi


SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

echo "Correct number of arguments: $#"
datadir=$1
trainedmodeldir=$2
epochs=$3
save_interval=$4

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash
  epochs=3
  save_interval=1
fi

echo "datadir: $datadir (note: really need that slash)"
echo "trainedmodeldir: $trainedmodeldir (note: really need that slash)"
echo "epochs: $epochs"
echo "save_interval: $save_interval"

#if [[ $HOSTNAME =~ "^r[0-9]{1,3}$" ]] ; then
if echo "$HOSTNAME" | egrep -q "^r[[:digit:]]{1,3}$"; then
  echo "Running on Rackham runner node $HOSTNAME"
  module load python/3.8.7
fi

python3 GenoCAE/run_gcae.py \
  train \
  --datadir $datadir \
  --data sim_data_1 \
  --trainedmodeldir $trainedmodeldir \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --epochs $epochs \
  --save_interval $save_interval \
  --pheno_model_id=p1

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"
