#!/bin/bash
#
# Create a .zip file to be used on Bianca
#
# Usage:
#
# ./create_bianca_zip.sh

# Download gcaer.sif
singularity pull library://richelbilderbeek/default/gcaer:v0.4 

# Download this repo
wget --output-document=nsphs_ml_qt.zip https://github.com/richelbilderbeek/nsphs_ml_qt/archive/v0.1.zip 

# Zip
zip nsphsmlqt_and_gcaer.zip gcaer_v0.4.sif nsphs_ml_qt.zip README.md run.sh

