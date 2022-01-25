#!/bin/bash
#
# Create a .zip file locally, with all starter files needed, 
# to be run locally
#
# Usage:
#
#   ./0_create_starter_zip.sh
#   ./scripts/0_create_starter_zip.sh
#

if [[ $HOSTNAME != "N141CU" ]]; then
  echo "Error: this script must run locally"
  echo "HOSTNAME: $HOSTNAME"
  exit 42
fi


zip -r --must-match 0_starter_zip.zip ~/GitHubs/gcaer/gcaer.sif ~/GitHubs/nsphs_ml_qt/scripts

