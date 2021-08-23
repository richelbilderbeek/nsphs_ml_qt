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
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --job-name=run
#SBATCH --output=run.log
cat nsphs_ml_qt-master/scripts/do_experiment.R | ./gcaer_v0.4.sif

