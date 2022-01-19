#!/bin/bash
#
# Start the experiment
#
# Usage:
#
#   ./run.sh
#   sbatch -A sens2021565 2_do_test_experiment.sh
#
#
#SBATCH --time=0:01:00
#SBATCH --partition core
#SBATCH --ntasks 1
##SBATCH --mem=1G
#SBATCH --job-name=2_run
#SBATCH --output=2_run.log
cat 2_do_experiment.R | ./gcaer_v0.4.sif

