#!/bin/bash
#
#For sbatch, the '-A' (e.g. '-A snic2021-22-624') is defined by caller
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#For sbatch, the '--job-name' is defined by caller
#For sbatch, the '--output' is defined by caller

echo "Parameters: $*"
echo "Number of parameters: $#"

if [[ "$#" -ne 1 ]] ; then
  echo "Invalid number of arguments: must have 1 parameter: "
  echo " "
  echo "  1. gcae_experiment_params_filename"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi

echo "Correct number of arguments: $#"
gcae_experiment_params_filename=$1
singularity_filename=nsphs_ml_qt/nsphs_ml_qt.sif

echo "gcae_experiment_params_filename: $gcae_experiment_params_filename"
echo "singularity_filename: ${singularity_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

singularity run $singularity_filename Rscript nsphs_ml_qt/scripts_bianca/22_create_issue_50_data.R "$gcae_experiment_params_filename"

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

