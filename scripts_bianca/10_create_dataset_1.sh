#!/bin/bash
#
# Create subsetted dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh
#
#
#SBATCH -A sens2021565
#SBATCH --time=1:00:00
#SBATCH --partition core
#SBATCH --ntasks 1
#SBATCH -C usage_mail
# From https://www.uppmax.uu.se/support/user-guides/slurm-user-guide
# Be light first
# Could do, for 256GB: -C mem256GB
# Could do, for 1TB: -C mem1TB
#SBATCH --mem=16G
#SBATCH --job-name=10_create_dataset_1
#SBATCH --output=10_create_dataset_1.log

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

full_data_basename=/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1
datadir=~/data_1/ # Really need that slash
plink_exe=~/.local/share/plinkr/plink_1_9_unix/plink
thin_count=10 # Number of SNPs that remain

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "This script is run locally"
  full_data_basename=~/GitHubs/nsphs_ml_qt/inst/extdata/nsphs_ml_qt_issue_4_bin
  thin_count=5 # Number of SNPs that remain
fi

full_data_bed_filename=$full_data_basename.bed
full_data_bim_filename=$full_data_basename.bim
full_data_fam_filename=$full_data_basename.fam
full_data_phe_filename=$full_data_basename.phe


echo "full_data_basename: $full_data_basename"
echo "datadir: $datadir"
echo "plink_exe: $plink_exe"
echo "full_data_bed_filename: $full_data_bed_filename"
echo "full_data_bim_filename: $full_data_bim_filename"
echo "full_data_fam_filename: $full_data_fam_filename"
echo "thin_count: $thin_count (i.e. number of SNPs that remain)"

if [ ! -f $plink_exe ]; then
  echo "'plink_exe' file not found at path $plink_exe"
  exit 42
fi

if [ ! -f $full_data_bed_filename ]; then
  echo "'full_data_bed_filename' file not found at path $full_data_bed_filename"
  exit 43
fi


mkdir $datadir

# * [ ] Do LD prune in PLINK, use R2 < 0.2
# * [x] Remove rare alleles, e.g. MAF <1%
# * [x] Take a random set of SNPs, that must be small enough for GCAE to load the .bed file

$plink_exe \
  --bfile $full_data_basename \
  --maf 0.01 \
  --thin-count $thin_count \
  --make-bed \
  --out $datadir/data_1

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Lowest MAF: "
  Rscript -e "min(plinkr::get_minor_alelle_frequencies(plinkr::read_plink_bin_data(\"$datadir/data_1\")$data))"
fi

echo "End time: $(date --iso-8601=seconds)"

