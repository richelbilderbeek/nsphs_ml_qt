#!/bin/bash
#
# Start the experiment
#
# Usage:
#
#   sbatch nsphs_ml_qt/scripts/4_create_subset_1.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 512GB: -C mem512GB
#SBATCH --mem=112G
#SBATCH --job-name=4_create_subset_1
#SBATCH --output=4_create_subset_1.log
cat nsphs_ml_qt/scripts/4_create_subset_1.R | gcaer/gcaer.sif

