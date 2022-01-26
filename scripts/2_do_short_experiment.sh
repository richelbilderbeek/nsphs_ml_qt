#!/bin/bash
#
# Start the experiment
#
# Usage:
#
#   sbatch nsphs_ml_qt/scripts/2_do_short_experiment.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
# 128G is a thin node, see https://www.uppmax.uu.se/support/user-guides/bianca-user-guide/ at 'Node types'
# 128G / 8 = 16G
#SBATCH --mem=16G
#SBATCH --job-name=2_do_short_experiment
#SBATCH --output=2_do_short_experiment.log
cat nsphs_ml_qt/scripts/2_do_short_experiment.R | gcaer/gcaer.sif

