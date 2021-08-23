#!/bin/bash
#
# Unzip the zips
#
# Usage: 
#
#   ./unzip.sh
#   sbatch -A snic2021-22-624 unzip.sh
#   sbatch -A sens2021565 unzip.sh
#
#
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=1_unzip
#SBATCH --output=1_unzip.log
unzip nsphs_ml_qt.zip

