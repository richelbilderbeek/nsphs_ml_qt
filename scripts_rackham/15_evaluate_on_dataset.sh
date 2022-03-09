#!/bin/bash
#
# Do the evaluation of dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh
#
# From the GCAE help:
#
# run_gcae.py evaluate --datadir=<name> --metrics=<name>  [  --data=<name>  --model_id=<name> --train_opts_id=<name> --data_opts_id=<name>  --superpops=<name> --epoch=<num> --trainedmodeldir=<name>  --pdata=<name> --trainedmodelname=<name>] [--pheno_model_id=<name>]
#
## No 'SBATCH -A snic2021-22-624', as this is a general script
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=15_evaluate_on_dataset
#SBATCH --output=15_evaluate_on_dataset-%j.log

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 6 ]] ; then
  echo "Invalid number of arguments: must have 6 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. data"
  echo "  3. trainedmodeldir"
  echo "  4. superpops"
  echo "  5. metrics"
  echo "  6. epoch"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

echo "Correct number of arguments: $#"
datadir=$1
data=$2
trainedmodeldir=$3
superpops=$4
metrics=$5
epoch=$6

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
echo "data: $data"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: $superpops"
echo "metrics: $metrics"
echo "epoch: $epoch"

if echo "$HOSTNAME" | egrep -q "^r[[:digit:]]{1,3}$"; then
  echo "Running on Rackham runner node $HOSTNAME"
  # module load python/3.8.7
fi

singularity run gcae/gcae.sif \
  evaluate \
  --datadir $datadir \
  --metrics $metrics \
  --data $data \
  --model_id M1 \
  --train_opts_id ex3 \
  --data_opts_id b_0_4 \
  --superpops $superpops \
  --epoch $epoch \
  --trainedmodeldir $trainedmodeldir \
  --pheno_model_id=p1

echo "End time: $(date --iso-8601=seconds)"
