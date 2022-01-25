#!/bin/bash
#
# Create a .zip file locally, with all starter files needed, 
# to be run locally
#
# Usage:
#
#   ./scripts/0_create_starter_zip.sh
#

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
  echo "  ./scripts/0_create_starter_zip.sh"
  exit 42
fi

# Go to GitHubs folder, will go back later
cd ..

cp nspshs/scripts/0_create_starter_zip.md README.md

zip -r --must-match 0_starter_zip.zip gcaer/gcaer.sif nsphs_ml_qt/scripts GenoCAE/ README.md

rm README.md

# Place the zip where it is expected to be
mv 0_starter_zip.zip nsphs_ml_qt/0_starter_zip.zip

# Go back to original folder
cd nsphs_ml_qt

