#!/bin/bash
#
# Create a .zip file to be used on Bianca
#
# Usage:
#
# ./create_bianca_zip.sh

# Download gcaer.sif
singularity pull library://richelbilderbeek/default/gcaer:v0.1

# Download this repo
wget https://github.com/richelbilderbeek/nsphs_ml_qt/releases/download/v0.1/nsphs_ml_qt-v0.1.tar.gz

# Zip
zip nsphsmlqt.zip nsphs_ml_qt-v0.1.tar.gz gcaer.sif
