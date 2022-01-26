#!/bin/bash
#
# Run setting 1
#
# Usage:
#
#   sbatch nsphs_ml_qt/scripts/3_run_setting_1.sh
#
# For Bianca:
##SBATCH -A sens2021565
# For Rackham:
#SBATCH -A snic2021-22-624
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=3_run_setting_1
#SBATCH --output=3_run_setting_1.log
cat nsphs_ml_qt/scripts/3_run_setting_1.R | gcaer/gcaer.sif

