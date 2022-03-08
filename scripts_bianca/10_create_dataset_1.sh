#!/bin/bash
#
# Create subsetted dataset 1
#
# Usage:
#
#   ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh
#
# Workflow:
#
#  1. check and process input
#  2. gcaer: extract a phenotype
#  3. PLINK: get a subset of the PLINK data
#  4. gcaer: create labels
#  5. gcaer: resize all data
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
#SBATCH --output=10_create_dataset_1-%j.log

###############################################################################
#  1. check and process input
###############################################################################

echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

echo "Parameters: $@"
echo "Number of parameters: $#"

if [[ "$#" -ne 5 ]] ; then
  echo "Invalid number of arguments: must have 5 parameters: "
  echo " "
  echo "  1. datadir"
  echo "  2. data"
  echo "  3. base_input_filename"
  echo "  4. superpops"
  echo "  5. thin_count"
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
thin_count=$5

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "superpops: ${superpops}"
echo "thin_count: ${thin_count}"

# That is, the full and real data: don't touch!
full_data_basename=/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1
out=$base_input_filename

out_data_bed_filename="${out}.bed" # These are generated, use freely :-)
out_data_bim_filename="${out}.bim" # These are generated, use freely :-)
out_data_fam_filename="${out}.fam" # These are generated, use freely :-)
out_data_phe_filename="${out}.phe" # These are generated, use freely :-)
out_data_phe_filename="${out}.phe" # These are generated, use freely :-)
out_data_labels_filename="${out}_labels.csv" # These are generated, use freely :-)
pheno="${out}.phe" # These are generated, use freely :-)
sample_ids_filename="${datadir}sample_ids.txt" # datadir ends with a slash
plink_exe=~/plink_1_9_unix/plink
singularity_filename=gcaer/gcaer.sif
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

full_data_bed_filename="${full_data_basename}.bed" # That is, the full and real data: don't touch!
full_data_bim_filename="${full_data_basename}.bim" # That is, the full and real data: don't touch!
full_data_fam_filename="${full_data_basename}.fam" # That is, the full and real data: don't touch!
full_data_phe_filename="${full_data_basename}.phe" # That is, the full and real data: don't touch!
column_index=1

echo "full_data_basename: ${full_data_basename} (i.e. the full and real data: don't touch!)"
echo "out: ${out}"
echo "pheno: ${pheno}"
echo "sample_ids_filename: ${sample_ids_filename}"
echo "plink_exe: ${plink_exe}"
echo "singularity_filename: ${singularity_filename}"
echo "full_data_bed_filename: ${full_data_bed_filename} (i.e. the full and real data: don't touch!)"
echo "full_data_bim_filename: ${full_data_bim_filename} (i.e. the full and real data: don't touch!)"
echo "full_data_fam_filename: ${full_data_fam_filename} (i.e. the full and real data: don't touch!)"
echo "full_data_phe_filename: ${full_data_phe_filename} (i.e. the full and real data: don't touch!)"
echo "column_index: ${column_index}"
echo "thin_count: ${thin_count} (i.e. number of SNPs that remain)"
echo "ld_window_size: ${ld_window_size}"
echo "ld_variant_count_shift: ${ld_variant_count_shift}"
echo "ld_r_squared_threshold: ${ld_r_squared_threshold}"

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


###############################################################################
#  2. gcaer: extract a phenotype
###############################################################################

echo "[START] 2. gcaer: extract a phenotype"

echo "Create phenotype file ${pheno} from dataset 1, column ${column_index}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_phenotypes.R $pheno $column_index
echo "Done creating phenotype file ${pheno} from dataset 1, column ${column_index}"

if [ ! -f $pheno ]; then
  echo "File 'pheno' not found at path ${pheno}"
  exit 45
fi

echo "[END] 2. gcaer: extract a phenotype"

###############################################################################
#  3. PLINK: get a subset of the PLINK data
###############################################################################

# * [x] Do LD prune in PLINK, use R2 < 0.2
# * [x] Remove rare alleles, e.g. MAF <1%
# * [x] Take a random set of SNPs, that must be small enough for GCAE to load the .bed file
# NOT NOW:  --maf $maf \
# NOT NOW: --indep-pairwise $ld_window_size $ld_variant_count_shift $ld_r_squared_threshold \
# USELESS: --pheno $pheno \
echo "[START] 3. PLINK: get a subset of the PLINK data"

$plink_exe \
  --bfile $full_data_basename \
  --thin-count $thin_count \
  --make-bed \
  --out $out

if [[ $HOSTNAME == "N141CU" ]]; then
  echo "Lowest MAF: "
  Rscript -e "min(plinkr::get_minor_alelle_frequencies(plinkr::read_plink_bin_data(\"${datadir}/${data}\")$data))"
fi

echo "[END] 3. PLINK: get a subset of the PLINK data"

###############################################################################
#  3.5. plinkr: fix fam file's FIDs
###############################################################################

echo "[START] 3.5. plinkr: fix fam file's FIDs"

echo "Fixing fam table at  ${$out_data_fam_filename}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_fam_table.R $out_data_fam_filename
echo "Done fixing fam table at  ${$out_data_fam_filename}"

echo "[END] 3.5. plinkr: fix fam file's FIDs"

###############################################################################
#  4. gcaer: create labels
###############################################################################

echo "[START] 4. gcaer: create labels"

echo "Creating 'labels_filename' ${superpops}"
singularity run $singularity_filename nsphs_ml_qt/scripts_bianca/10_create_dataset_1_labels.R $pheno $superpops
echo "Done creating 'labels_filename' at ${superpops}"

echo "[END] 4. gcaer: create labels"

###############################################################################
#  5. gcaer: resize all data
###############################################################################

echo "[START] 5. gcaer: resize all data"

singularity run $singularity_filename \
  nsphs_ml_qt/scripts_bianca/10_resize_data.R \
  $out_data_bed_filename \
  $out_data_bim_filename \
  $out_data_fam_filename \
  $out_data_phe_filename \
  $superpops

echo "[END] 5. gcaer: resize all data"

echo "End time: $(date --iso-8601=seconds)"

# Thanks Jerker Nyberg von Below and Douglas Scofield
jobstats -r -d -p $SLURM_JOBID
