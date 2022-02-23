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
#
#
# Bash coding style from 
# https://google.github.io/styleguide/shellguide.html
#
## No 'SBATCH -A sens2021565', as this is a general script (although it is quite specific :-) )
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

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 4 ]] ; then
  echo "Invalid number of arguments: must have 4 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. data"
  echo "  3. base_input_filename"
  echo "  4. superpops"
  echo " "
  echo "Actual number of parameters: $#"
  echo " "
  echo "Exiting :-("
  exit 42
fi

echo "Correct number of arguments: $#"
datadir=$1
data=$2
base_input_filename=$3
superpops=$4

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "superpops: ${superpops}"

full_data_basename=/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1
out=$base_input_filename
pheno="${out}.phe" # datadir ends with a slash
sample_ids_filename="${datadir}sample_ids.txt" # datadir ends with a slash
plink_exe=~/plink_1_9_unix/plink
singularity_filename=gcaer/gcaer.sif
thin_count=10 # Number of SNPs that remain
maf=0.01 # Minimal frequency of alleles
ld_window_size=1000
ld_variant_count_shift=1
ld_r_squared_threshold=0.2

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "This script is run locally"
  plink_exe=~/.local/share/plinkr/plink_1_9_unix/plink
  full_data_basename=~/GitHubs/nsphs_ml_qt/inst/extdata/nsphs_ml_qt_issue_4_bin
  full_data_basename=~/nsphs_ml_qt_issue_4_bin
  thin_count=10 # Number of SNPs that remain
fi

full_data_bed_filename="${full_data_basename}.bed"
full_data_bim_filename="${full_data_basename}.bim"
full_data_fam_filename="${full_data_basename}.fam"
full_data_phe_filename="${full_data_basename}.phe"
column_index=1

echo "full_data_basename: ${full_data_basename}"
echo "out: ${out}"
echo "pheno: ${pheno}"
echo "sample_ids_filename: ${sample_ids_filename}"
echo "plink_exe: ${plink_exe}"
echo "singularity_filename: $singularity_filename"
echo "full_data_bed_filename: $full_data_bed_filename"
echo "full_data_bim_filename: $full_data_bim_filename"
echo "full_data_fam_filename: $full_data_fam_filename"
echo "full_data_phe_filename: $full_data_phe_filename"
echo "column_index: $column_index"
echo "thin_count: $thin_count (i.e. number of SNPs that remain)"
echo "ld_window_size: $ld_window_size"
echo "ld_variant_count_shift: $ld_variant_count_shift"
echo "ld_r_squared_threshold: $ld_r_squared_threshold"

if [ ! -f $plink_exe ]; then
  echo "'plink_exe' file not found at path $plink_exe"
  exit 42
fi

if [ ! -f $singularity_filename ]; then
  echo "'singularity_filename' file not found at ${singularity_filename}"
  exit 43
fi


if [ ! -f $full_data_bed_filename ]; then
  echo "'full_data_bed_filename' file not found at path ${full_data_bed_filename}"
  exit 44
fi


# -p denotes no warning if folder already exists
mkdir -p $datadir

echo "Create phenotype file ${pheno} from dataset 1, column ${column_index}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_phenotypes.R $pheno $column_index
# Rscript nsphs_ml_qt/scripts_bianca/10_create_dataset_1_phenotypes.R $pheno $column_index
echo "Done creating phenotype file ${pheno} from dataset 1, column ${column_index}"

if [ ! -f $pheno ]; then
  echo "File 'pheno' not found at path ${pheno}"
  exit 45
fi

echo "Creating sample IDs file at ${sample_ids_filename}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_phenotype_sample_ids.R $pheno $sample_ids_filename
echo "Done creating sample IDs file at ${sample_ids_filename}"

if [ ! -f $sample_ids_filename ]; then
  echo "File 'sample_ids_filename' not found at path ${sample_ids_filename}"
  exit 46
fi

echo "Keep the samples with IDs in the 'sample_ids_filename'"
$plink_exe \
  --bfile $full_data_basename \
  --keep $sample_ids_filename \
  --make-bed \
  --out $out

# * [x] Do LD prune in PLINK, use R2 < 0.2
# * [x] Remove rare alleles, e.g. MAF <1%
# * [x] Take a random set of SNPs, that must be small enough for GCAE to load the .bed file
# NOT NOW:  --maf $maf \
# NOT NOW: --indep-pairwise $ld_window_size $ld_variant_count_shift $ld_r_squared_threshold \
# USELESS: --pheno $pheno \
echo "Calling PLINK"

$plink_exe \
  --bfile $out \
  --thin-count $thin_count \
  --make-bed \
  --out $out

echo "Done call to PLINK"

echo "Creating 'labels_filename' ${superpops}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_labels.R $pheno $superpops
echo "Done creating 'labels_filename' at ${superpops}"

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Lowest MAF: "
  Rscript -e "min(plinkr::get_minor_alelle_frequencies(plinkr::read_plink_bin_data(\"${datadir}/${data}\")$data))"
fi

echo "End time: $(date --iso-8601=seconds)"

# Thanks Jerker Nyberg von Below and Douglas Scofield
# Really need the -r
jobstats -r -p $SLURM_JOBID


