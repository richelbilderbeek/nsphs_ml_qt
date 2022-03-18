#!/bin/bash
#
# Train on dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh
#
# From the GCAE help:
#
#   run_gcae.py train --datadir=<name> --data=<name> --model_id=<name> --train_opts_id=<name> --data_opts_id=<name> --save_interval=<num> --epochs=<num> [--resume_from=<num> --trainedmodeldir=<name> ] [--pheno_model_id=<name>]
#
# n_individuals| n_traits | n_snps | n_epochs | run_time (mins) | memory_used (GB) | Comments
# -------------|----------|--------|----------|-----------------|------------------|------------------------------------------------------
# 500          | 40       | 1200   | 100      | <60             | .                |
# 500          | 40       | 1200   | 1000     | 110             | .                |
# 500          | 40       | 1200   | 1000     | 110             | .                |
# 1000         | 1        | 10     | 10       | <5              | .                |
# 1000         | 1        | 1k     | 100      | 25              | .                |
# 1000         | 1        | 1k     | 1k       | 241             | 2.4              | https://github.com/AJResearchGroup/richel/issues/129
# 1000         | 1        | 10k    | 200      | 400             | 3.7              |
# 1000         | 1        | 1      | 1k       | 26              | .                | https://github.com/AJResearchGroup/richel/issues/126
# 1000         | 1        | 100k   | 200      | ?4000           | .                | https://github.com/AJResearchGroup/richel/issues/130
#
# Issue | C | n_snps | run_time (mins) | memory_used (GH)
# ------+---+--------+-----------------+-----------------
# 106   | R |        |                 |
# 126   | R |        | 26              |
# 127   | R |        |                 |
# 129   | B | 1k     | 241             | 2.4
# 130   | B | 100k   | >600/?4000      |
# 136   | B |        |                 |
# 140   | R |        |                 |
#
#
# job | memory_used (GH)
# ----+--------------------
# 573 | 12.47
# 549 | 12.06
#
## No 'SBATCH -A snic2021-22-624', as this is a general script
#SBATCH --time=100:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=11_train_on_dataset
#Log filename: 11_train_on_dataset.log

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 6 ]] ; then
  echo "Invalid number of arguments: must have 6 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. data"
  echo "  3. trainedmodeldir"
  echo "  4. epochs"
  echo "  5. save_interval"
  echo "  6. pheno_model_id"
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
pheno_model_id=$6

echo "datadir: $datadir (note: really need that slash)"
echo "data: $data"
echo "trainedmodeldir: $trainedmodeldir (note: really need that slash)"
echo "epochs: $epochs"
echo "save_interval: $save_interval"
echo "pheno_model_id: ${pheno_model_id}"

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
  --pheno_model_id $pheno_model_id

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

echo "Show the jobstats,  with header, thanks Douglas and Jerker"
jobstats -r -d -p $SLURM_JOBID
