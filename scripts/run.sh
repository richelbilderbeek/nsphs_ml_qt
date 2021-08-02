#!/bin/bash
#
# Start the experiment
#
# Usage: sbatch run.sh
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --job-name=richel
#SBATCH --output=richel.log
cat nsphs_ml_qt-master/scripts/do_experiment.R | ./gcaer_v0.4.sif

