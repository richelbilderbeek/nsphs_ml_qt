#!/bin/bash
#
# Run setting 1
#
# Usage:
#
#   sbatch nsphs_ml_qt/scripts/3_run_setting_1.sh
#
#SBATCH -A sens2021565
#SBATCH --time=0:01:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=3_run_setting_1
#SBATCH --output=3_run_setting_1.log
cat nsphs_ml_qt/scripts/3_run_setting_1.R | gcaer/gcaer.sif

