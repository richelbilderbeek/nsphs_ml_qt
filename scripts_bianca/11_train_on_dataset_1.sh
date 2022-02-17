#!/bin/bash
#
# Train on dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_bianca/11_train_on_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_bianca/11_train_on_dataset_1.sh
#
# From the GCAE help:
#
#   run_gcae.py train --datadir=<name> --data=<name> --model_id=<name> --train_opts_id=<name> --data_opts_id=<name> --save_interval=<num> --epochs=<num> [--resume_from=<num> --trainedmodeldir=<name> ] [--pheno_model_id=<name>]
#
#SBATCH -A sens2021565
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

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

datadir=~/data_1/ # Really need that slash
data=data_1
trainedmodeldir=~/data_1_ae/ # Really need that slash
epochs=3
save_interval=1

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash
  epochs=3
  save_interval=1
fi

echo "datadir: $datadir"
echo "trainedmodeldir: $trainedmodeldir"
echo "epochs: $epochs"
echo "save_interval: $save_interval"

# module load python/3.8.7

singularity run gcae/gcae.sif \
  train \
  --datadir $datadir \
  --data $data \
  --trainedmodeldir $trainedmodeldir \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --epochs $epochs \
  --save_interval $save_interval \
  --pheno_model_id=p1

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"
