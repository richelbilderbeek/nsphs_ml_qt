#!/bin/bash
#
# Start the experiment
#
# Usage:
#
#   ./run.sh
#   sbatch -A snic2021-22-624 run.sh
#   sbatch -A sens2021565 run.sh
#
#
#SBATCH --time=0:01:00
#SBATCH --partition core
#SBATCH --ntasks 1
##SBATCH --mem=1G
#SBATCH --job-name=2_run
#SBATCH --output=2_run.log
cat nsphs_ml_qt-master/scripts/do_experiment.R | ./gcaer_v0.4.sif

