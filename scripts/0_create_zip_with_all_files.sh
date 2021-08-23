#!/bin/bash
#
# Create a .zip file with all files needed, 
# to be run on either Rackham or Bianca
#
# Usage:
#
# ./0_create_zip_with_all_files.sh

# Remove possible old files
rm -rf gcaer_v0.4.sif
rm -rf nsphs_ml_qt.zip

# Download gcaer.sif
singularity pull library://richelbilderbeek/default/gcaer:v0.4 

# Download this repo
wget --output-document=nsphs_ml_qt.zip https://github.com/richelbilderbeek/nsphs_ml_qt/archive/master.zip
# wget --output-document=nsphs_ml_qt.zip https://github.com/richelbilderbeek/nsphs_ml_qt/archive/v0.1.1.zip


# Zip
zip nsphsmlqt_and_gcaer.zip gcaer_v0.4.sif nsphs_ml_qt.zip README.md *.sh HumanOrigins249_tiny.*

rm -rf gcaer_v0.4.sif
rm -rf nsphs_ml_qt.zip
