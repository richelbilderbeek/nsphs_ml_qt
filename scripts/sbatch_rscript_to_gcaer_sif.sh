#!/bin/bash
#
# Run an R script using the gcaer.sif Singularity container
#
# Usage:
#
#   ./sbatch_r_script_to_gcaer_sif.sh my_r_script.R
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
