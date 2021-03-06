#!/bin/bash
#
# Create a .zip file locally, with all starter files needed, 
# to be run locally
#
# Usage:
#
#   ./scripts_bianca/00_create_starter_zip.sh
#
#
#

zip_filename=nsphs_ml_qt_starter_zip.zip

SECONDS=0
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"
echo "zip_filename: $zip_filename"

if [[ $HOSTNAME != "N141CU" ]]; then
  echo "Error: this script must run locally"
  echo "HOSTNAME: $HOSTNAME"
  exit 42
fi

if [[ $(pwd) != "/home/richel/GitHubs/nsphs_ml_qt" ]]; then
  echo "Error: this script must run from '/home/richel/GitHubs/nsphs_ml_qt'"
  echo "pwd: $(pwd)"
  echo ""
  echo "Tip: run this script by using:"
  echo ""
  echo "  ./scripts_bianca/00_create_starter_zip.sh"
  exit 42
fi

# Delete the zip if it exists, else it will zip recursively
rm -f $zip_filename

# Go to GitHubs folder, will go back later
cd ..

# Copy files for in the zip's root
cp nsphs_ml_qt/scripts_bianca/README.md README.md
cp nsphs_ml_qt/scripts_bianca/98_clean_bianca.sh 98_clean_bianca.sh

# Use nsphs_ml_qt.sif in nsphs_ml_qt
# Thanks https://silicondales.com/tutorials/linux/unix-linux-zip-contents-folder-excluding-certain-sub-folders/#Recursively_zip_a_directory_and_all_contents_-_excluding_one_subdirectory
zip -r \
  --must-match $zip_filename \
  nsphs_ml_qt/ \
  README.md 98_clean_bianca.sh \
  --exclude nsphs_ml_qt/.git/**\* \
  --exclude nsphs_ml_qt/.Rproj.user/**\*

# Remove files for in the zip's root
rm README.md 98_clean_bianca.sh

# Place the zip where it is expected to be
mv $zip_filename nsphs_ml_qt/$zip_filename

# Go back to original folder
cd nsphs_ml_qt || exit

if [[ $HOSTNAME == "N141CU" ]]; then
  notify-send "Done creating starter zip" "with filename $zip_filename"
fi

echo "Duration: $SECONDS seconds"
