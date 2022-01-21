#!/bin/bash
#
# Create a .zip file with all starter files needed, 
# to be run on either Rackham or Bianca
#
# Usage:
#
#   ./0_create_starter_zip.sh
#   sbatch -A snic2021-22-624 0_create_starter_zip.sh
#   sbatch -A sens2021565 0_create_starter_zip.sh
#
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=0_create_starter_zip
#SBATCH --output=0_create_starter_zip.log

# Remove possible old files
rm -rf gcaer_*.sif
rm -rf nsphs_ml_qt.zip

# Download gcaer.sif
singularity pull library://richelbilderbeek/default/gcaer:0.5.0.1
mv gcaer_0.5.0.1.sif gcaer.sif

# Download this repo
wget --output-document=nsphs_ml_qt.zip https://github.com/richelbilderbeek/nsphs_ml_qt/archive/master.zip

# Zip
zip nsphsmlqt_and_gcaer.zip gcaer.sif nsphs_ml_qt.zip

rm -rf gcaer.sif
rm -rf nsphs_ml_qt.zip

# Cannot do, as job is not finished yet
#
# if command -v finishedjobinfo &> /dev/null
# then
#   finishedjobinfo -j $SLURM_JOB_ID
# fi

