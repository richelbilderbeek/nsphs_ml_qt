#!/bin/bash
#
# Clean up, by removing all files except itself
#
# Usage: 
#
#   ./clean.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --job-name=clean
#SBATCH --output=clean.log
rm -f *.zip
rm -f *.sif
rm -f run.sh
rm -f 1_unzip.sh
rm -f 2_sbatch_run.sh
rm -f create_bianca_zip.sh 
rm -f *.md
rm -rf nsphs_ml_qt-master
