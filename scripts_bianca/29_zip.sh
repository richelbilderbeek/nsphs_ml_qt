#!/bin/bash
#
# Create a zip file that can be copied,
# as it contains only summary statistics.
# Care is taken to exclude all personal info,
# see https://github.com/richelbilderbeek/nsphs_ml_qt/issues/5
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
singularity_filename=nsphs_ml_qt/nsphs_ml_qt.sif

echo "gcae_experiment_params_filename: $gcae_experiment_params_filename"
echo "singularity_filename: ${singularity_filename}"

unique_id=$(echo "$gcae_experiment_params_filename" | grep -E -o "issue_[[:digit:]]+")
echo "unique_id: ${unique_id}"

datadir=$(grep -E datadir "$gcae_experiment_params_filename" | cut -d , -f 2)
echo "datadir: ${datadir}"


trainedmodeldir=$(grep -E trainedmodeldir "$gcae_experiment_params_filename" | cut -d , -f 2)
echo "trainedmodeldir: ${trainedmodeldir}"

zip_filename=~/${unique_id}.zip
echo "zip_filename: ${zip_filename}"

sensitive_zip_filename=~/${unique_id}_sensitive.zip
echo "sensitive_zip_filename: ${sensitive_zip_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

log_filenames=$(compgen -G "*.log" | grep -E "${unique_id}")

echo "datadir: ${datadir}"
echo "trainedmodeldir: ${trainedmodeldir}"
echo "unique_id: ${unique_id}"
echo "zip_filename: ${zip_filename}"
echo "log_filenames: ${log_filenames}"

datadir_basename=$(basename "$datadir")
trainedmodeldir_basename=$(basename "$trainedmodeldir")
weights_filenames=$(find . | grep -E "weights/")
phenotype_predictions_filename=$(find . | grep -E "${trainedmodeldir_basename}.phenotype_predictions.csv")
superpop_legends_filenames=$(find . | grep -E "${trainedmodeldir_basename}.*_by_superpop_legends.pdf")

zip -r "$zip_filename" $log_filenames "$datadir_basename" "$trainedmodeldir_basename" --exclude ./*.bed ./*.bim ./*.fam ./*.phe ./*.phe ./*.pdf ./*.v2 $weights_filenames $phenotype_predictions_filename $superpop_legends_filenames

zip -r "$sensitive_zip_filename" $log_filenames "$datadir_basename" "$trainedmodeldir_basename"

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

