#!/bin/bash
#
# Unzip the zips
#
# Usage: 
#
#   ./unzip.sh
#   sbatch ./unzip.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --job-name=unzip
#SBATCH --output=unzip.log
unzip nsphs_ml_qt.zip

