#!/bin/bash
#
# Zip the results for further analysis:
#
#  * The '.log' files
#    * Shorten '11_train_[unique_id].log' 
#  * the 'trainedmodeldir' folder
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/17_zip_results.sh [arguments]
#

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 2 ]] ; then
  echo "Invalid number of arguments: must have 2 parameters: "
  echo " "
  echo "  1. trainedmodeldir"
  echo "  2. unique_id"
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
trainedmodeldir=$1
unique_id=$2

zip_filename="${unique_id}.zip"
11_train_filename="11_train_${unique_id}.log"
11_train_filename_backup="11_train_${unique_id}.bak"
log_filenames=$(ls *.log | egrep "${unique_id}")

echo "trainedmodeldir: ${trainedmodeldir}"
echo "unique_id: ${unique_id}"
echo "zip_filename: ${zip_filename}"

echo "11_train_filename: ${11_train_filename}"
echo "11_train_filename_backup: ${11_train_filename_backup}"
echo "log_filenames: ${log_filenames}"

echo "'11_train_[unique_id].log' is big, only use the start and end of it"
cp $11_train_filename $11_train_filename_backup
head $11_train_filename_backup -n 70 > $11_train_filename
tail $11_train_filename_backup -n 10 >> $11_train_filename
rm $11_train_filename_backup

zip -r $zip_filename $log_filenames $(basename $trainedmodeldir) --exclude *.png

