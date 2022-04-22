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
#SBATCH --time=0:05:00

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
train_filename="11_train_${unique_id}.log"
train_filename_backup="11_train_${unique_id}.bak"
log_filenames=$(ls *.log | grep -E "${unique_id}")

echo "trainedmodeldir: ${trainedmodeldir}"
echo "unique_id: ${unique_id}"
echo "zip_filename: ${zip_filename}"

echo "train_filename: ${train_filename}"
echo "train_filename_backup: ${train_filename_backup}"
echo "log_filenames: ${log_filenames}"

echo "'11_train_[unique_id].log' is big, only use the start and end of it"
cp $train_filename $train_filename_backup
head $train_filename_backup -n 70 > $train_filename
tail $train_filename_backup -n 10 >> $train_filename
rm $train_filename_backup

zip -r $zip_filename $log_filenames $(basename $trainedmodeldir) --exclude *.phe $(find . | grep -E "weights/")

echo "Duration: $SECONDS seconds"

