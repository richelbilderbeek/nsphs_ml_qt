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
zip -r --must-match 0_starter_zip.zip ~/GitHubs/gcaer/gcaer.sif ~/GitHubs/nsphs_ml_qt/scripts

