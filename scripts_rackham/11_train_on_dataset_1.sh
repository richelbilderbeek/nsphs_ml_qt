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
# n_individuals| n_traits | n_snps_per_trait | epochs | Time (mins)    | Memory used (GB)
# 500          | 40       | 30               | 100    | <60            | .
# 500          | 40       | 30               | 1000   | 110            | .
# 500          | 40       | 30               | 1000   | 110            | .
# 1000         | 1        | 10               | 10     | <5             | .
# 1000         | 1        | 1k               | 100    | 25             | .
# 1000         | 1        | 10k              | 200    | 400            | 3.7
# 1000         | 1        | 1000             | 1k     | estimated: 250 | .
#
#
#
## No 'SBATCH -A snic2021-22-624', as this is a general script
#SBATCH --time=10:00:00
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

if [[ "$#" -ne 5 ]] ; then
  echo "Invalid number of arguments: must have 5 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. data"
  echo "  3. trainedmodeldir"
  echo "  4. epochs"
  echo "  5. save_interval"
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
data=$2
trainedmodeldir=$3
epochs=$4
save_interval=$5

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Running on local computer"
  datadir=/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/ # Really need that slash
  epochs=3
  save_interval=1
fi

echo "datadir: $datadir (note: really need that slash)"
echo "data: $data"
echo "trainedmodeldir: $trainedmodeldir (note: really need that slash)"
echo "epochs: $epochs"
echo "save_interval: $save_interval"

if echo "$HOSTNAME" | egrep -q "^r[[:digit:]]{1,3}$"; then
  echo "Running on Rackham runner node $HOSTNAME"
  # module load python/3.8.7
fi

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

echo "Show the jobstats,  with header, thanks Douglas and Jerker"
jobstats -r -d -p $SLURM_JOBID
