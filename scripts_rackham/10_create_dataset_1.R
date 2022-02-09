#
# Create simulated data in inst/extdata
#
# Usage:
#
#   Rscript nsphs_ml_qt/scripts_rackham/10_create_dataset_1.R
#

is_on_gha <- function() {
  Sys.getenv("GITHUB_ACTIONS") != ""
}

is_on_rackham <- function() {
  stringr::str_count(
    string = Sys.getenv("HOSTNAME"),
    pattern = "^r[:digit:]{1,3}$"
  ) == 1
}

if (is_on_gha()) {
  message("This R script runs on GitHub Actions")
  if (plinkr::is_plink_installed()) {
    message("PLINKs are already installed")
  } else {
    message("Installing PLINKs")
    plinkr::install_plinks()
    message("PLINKs installed")
  }
}
if (is_on_rackham()) {
  message("This R script runs on Rackham")
  if (plinkr::is_plink_installed()) {
    message("PLINK are already installed")
  } else {
    message("Installing PLINKs")
    plinkr::install_plinks()
    message("PLINKs installed")
  }
}

if [[ $HOSTNAME =~ ^r[0-9]{1-3}$ ]] ; then
  echo "Running on Rackham runner node"
  # No need to load modules here
  # module load python/3.8.7
fi


gcaer::create_gcae_input_files_1(
  base_input_filename = "nsphs_ml_qt/inst/extdata/sim_data_1"
)


