#!/bin/bash
#
# Start the experiment
#
# Usage:
#
#   ./run.sh
#   sbatch 2_do_short_experiment.sh
#
#SBATCH -A sens2021565
#SBATCH --time=0:01:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=2_do_short_experiment
#SBATCH --output=2_do_short_experiment.log
cat 2_do_short_experiment.R | ./gcaer.sif

