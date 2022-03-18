#!/bin/bash
#
# Zip the results for further analysis:
#
#  * The '.log' files
#  * the 'datadir' folder
#  * the 'trainedmodeldir' folder
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh [arguments]
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

zip_filename="${unique_id}.zip"
log_filenames=$(ls *.log | egrep "${unique_id}")

echo "datadir: ${datadir}"
echo "trainedmodeldir: ${trainedmodeldir}"
echo "unique_id: ${unique_id}"
echo "zip_filename: ${zip_filename}"
echo "log_filenames: ${log_filenames}"

zip -r $zip_filename $log_filenames $(basename $datadir) $(basename $trainedmodeldir) --exclude $(find . | egrep "weights/")
