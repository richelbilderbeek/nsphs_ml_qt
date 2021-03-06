#!/bin/bash
#
# Create a zip file for issue #42 that can be copied,
# as it contains only summary statistics.
# Care is taken to exclude all personal info,
# see https://github.com/richelbilderbeek/nsphs_ml_qt/issues/5
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=16G
#SBATCH --job-name=29_zip_issue_42
#SBATCH --output=29_zip_issue_42.log

unique_id="issue_42"
echo "unique_id: ${unique_id}"

zip_filename=~/${unique_id}.zip
echo "zip_filename: ${zip_filename}"

sensitive_zip_filename=~/${unique_id}_sensitive.zip
echo "sensitive_zip_filename: ${sensitive_zip_filename}"

SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

echo "########################################################################"
echo "# 1/2: from home folder: copy log files"
echo "########################################################################"
echo "unique_id: ${unique_id}"
log_filenames=$(compgen -G "*.log" | grep -E "${unique_id}")
folder_names=$(ls data_issue_42_* --directory)

# 'mv' will cause 'zi...' files, as log files for runs that are in progress
# are suddenly moved
cp --target-directory=/proj/sens2021565/nobackup/nsphs_ml_qt_results $log_filenames

echo "########################################################################"
echo "# 2/2: from target folder: zip"
echo "########################################################################"
echo "Change to new folder: /proj/sens2021565/nobackup/nsphs_ml_qt_results"
cd /proj/sens2021565/nobackup/nsphs_ml_qt_results

echo "unique_id: ${unique_id}"
echo "zip_filename: ${zip_filename}"
echo "log_filenames (they will ): ${log_filenames}"
echo "folder_names: ${folder_names}"

weights_filenames=$(find . | grep -E "weights/")
phenotype_predictions_filename=$(find . | grep -E "phenotype_predictions.csv$")
superpop_legends_filenames=$(find . | grep -E "_by_superpop_legends.pdf$")

# shellcheck disable=SC2086 # word splitting is intended for '$log_filenames'
zip -r "$zip_filename" $log_filenames $folder_names --exclude ./*.bed ./*.bim ./*.fam ./*.phe ./*.phe ./*.pdf ./*.v2 $weights_filenames $phenotype_predictions_filename $superpop_legends_filenames

# shellcheck disable=SC2086 # word splitting is intended for '$log_filenames'
zip -r "$sensitive_zip_filename" $log_filenames $folder_names

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

