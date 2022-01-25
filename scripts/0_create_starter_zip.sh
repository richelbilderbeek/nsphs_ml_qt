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

zip -r --must-match --paths ~/GitHubs 0_starter_zip.zip ~/GitHubs/gcaer/gcaer.sif ~/GitHubs/nsphs_ml_qt/scripts

