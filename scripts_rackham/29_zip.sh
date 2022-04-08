#!/bin/bash
#
## No 'SBATCH -A snic2021-22-624', as this is a general script
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#For sbatch, '--job-name' is defined by caller
#Log filename: is defined by caller

echo "Parameters: $@"
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
singularity_filename=gcaer/gcaer.sif

echo "gcae_experiment_params_filename: $gcae_experiment_params_filename"
echo "singularity_filename: ${singularity_filename}"

unique_id=$(echo $gcae_experiment_params_filename | egrep -o "issue_[[:digit:]]+")
echo "unique_id: ${unique_id}"

trainedmodeldir=$(cat $gcae_experiment_params_filename | egrep trainedmodeldir | cut -d , -f 2)
echo "trainedmodeldir: ${trainedmodeldir}"

zip_filename=~/${unique_id}.zip
echo "zip_filename: ${zip_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

zip -r $zip_filename $trainedmodeldir

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

