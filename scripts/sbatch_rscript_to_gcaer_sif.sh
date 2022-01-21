#!/bin/bash
#
# Run an R script using the gcaer.sif Singularity container
#
# Usage:
#
#   # Using sbatch
#   sbatch sbatch_r_script_to_gcaer_sif.sh my_r_script.R
#   # Run locally
#   ./sbatch_r_script_to_gcaer_sif.sh my_r_script.R
#
# Some calls used in the experiment:
#
#   sbatch scripts/sbatch_rscript_to_gcaer_sif.sh scripts/2_do_short_experiment.R
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=sbatch_r_script_to_gcaer_sif
#SBATCH --output=sbatch_r_script_to_gcaer_sif.log
echo "cat $@ | ./richel-sens2021565/gcaer.sif"
cat "$@" | ./richel-sens2021565/gcaer.sif
