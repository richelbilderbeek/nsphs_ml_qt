#
# Create a subset of the data to observe dimensionality reduction
#
#  * Do LD prune in PLINK, use R2 < 0.2
#  * Remove rare alleles, e.g. MAF <1%
#  * Take a random set of SNPs, 
#    that must be small enough for GCAE to load the .bed file
#
# see https://github.com/AJResearchGroup/richel/issues/109
#
# Usage:
#
# cat scripts/4_create_subset_1.R | ./gcaer.sif
#

library(gcaer)

# The genetic data folder, datadir must end with a slash
datadir <- "/proj/sens2021565/nobackup/NSPHS_data/"
# 'data' is the base file name for the original data
data <- "NSPHS.WGS.hg38.plink1"

base_input_filename <- paste0(datadir, data)
base_output_filename <- paste0(datadir, "dataset_1")

# Be verbose
message("base_input_filename: ", base_input_filename)
message("base_output_filename: ", base_output_filename)

plink_bin_filenames <- plinkr::filter_random_snps(
  base_input_filename = base_input_filename,
  base_output_filename = base_output_filename,
  n_snps = 100,
  verbose = TRUE
)

plink_bin_filenames

