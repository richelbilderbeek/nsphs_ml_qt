#!/bin/bash
#
# Analyse the results without any personal data
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_bianca/16_create_tidy_results.sh [arguments]
#

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 3 ]] ; then
  echo "Invalid number of arguments: must have 3 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. trainedmodeldir"
  echo "  3. unique_id"
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
unique_id=$3
singularity_filename=gcaer/gcaer.sif

echo "datadir: ${datadir}"
echo "trainedmodeldir: ${trainedmodeldir}"
echo "unique_id: ${unique_id}"
echo "singularity_filename: ${singularity_filename}"

echo "Start Singularity (from bash)"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/16_create_tidy_results.R $datadir $trainedmodeldir $unique_id
echo "Singularity done (from bash)"
