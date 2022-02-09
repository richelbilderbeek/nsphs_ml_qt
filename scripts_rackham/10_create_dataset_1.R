#
# Create simulated data in inst/extdata
#
# Usage:
#
#   Rscript nsphs_ml_qt/scripts_rackham/10_create_dataset_1.R
#
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 4) {
  stop(
    "Invalid number of arguments: must have 4 parameters: \n",
    " \n",
    "  1. base_input_filename \n",
    "  2. n_individuals \n",
    "  3. n_traits \n",
    "  4. n_snps_per_trait \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

base_input_filename <- args[1]
n_individuals <- args[2]
n_traits <- args[3]
n_snps_per_trait <- args[4]


message("base_input_filename: ", base_input_filename)

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
    plinkr::install_plink()
    message("PLINKs installed")
  }
}

gcaer::create_gcae_input_files_1(
  base_input_filename = base_input_filename
  n_individuals = n_individuals,
  n_traits = n_traits,
  n_snps_per_trait = n_snps_per_trait
)

