#!/bin/bash
#
# Notes on how to subset PLINK data
#
# Usage (from any folder):
#
#   ./subset_data.sh
#
Rscript -e 'readr::write_delim(x = plinkr::read_plink_fam_file(gcaer::get_gcaer_filename("gcae_input_files_1.fam"))[seq(1, 3), c(1, 2)], file = "sample_ids.txt", col_names = FALSE)'

cat sample_ids.txt

/home/richel/.local/share/plinkr/plink_1_9_unix/plink \
  --bfile ~/GitHubs/gcaer/inst/extdata/gcae_input_files_1 \
  --keep sample_ids.txt \
  --make-bed \
  --out subsetted_data

Rscript -e 'plinkr::read_plink_bin_data("subsetted_data")'


