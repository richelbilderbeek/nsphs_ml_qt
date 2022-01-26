#!/bin/bash
#
# Run setting 1
#
# Usage:
#
#   sbatch nsphs_ml_qt/scripts/3_run_setting_1.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
# 128G is a thin node, see https://www.uppmax.uu.se/support/user-guides/bianca-user-guide/ at 'Node types'
# 128G / 8 = 16G
#SBATCH --mem=16G
#SBATCH --job-name=3_run_setting_1
#SBATCH --output=3_run_setting_1.log
cat nsphs_ml_qt/scripts/3_run_setting_1.R | gcaer/gcaer.sif

