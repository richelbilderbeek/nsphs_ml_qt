#!/bin/bash
#
# Unzip the zips
#
# Usage: 
#
#   ./1_unzip.sh
#   sbatch -A snic2021-22-624 1_unzip.sh
#   sbatch -A sens2021565 1_unzip.sh
#
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH --mem=1G
#SBATCH --job-name=1_unzip
#SBATCH --output=1_unzip.log
unzip -y nsphsmlqt_and_gcaer.zip

# a README from the zip is extracted, that is usually the same as the local README.md
# (as it was zipped in step 0). Just to be sure, the newest version of README.md
# is pulled
git pull
