# Create subset 1 from the data
#
# Extracts the 'column_index'-th phenotype, (e.g. Adrenomedullin for '1'),
# from
#
# /proj/sens2021565/nobackup/NSPHS_data/pea_1_2.rntransformed.AJ.RData
#
# and saves it to a file named 'pheno'
#
args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  args <- "~/data_richel_issue_129/experiment_params.csv"
}

if (length(args) != 1) {
  stop(
    "Invalid number of arguments: must have 1 parameter: \n",
    " \n",
    "  1. gcae_experiment_params_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

gcae_experiment_params_filename <- args[1]
message("gcae_experiment_params_filename: ", gcae_experiment_params_filename)
gcaer::check_gcae_experiment_params_filename(gcae_experiment_params_filename)

message("Parameters are valid")

column_index <- 1
message("column_index: ", column_index)
gcaer::check_epoch(column_index)
testthat::expect_true(column_index >= 1)

snp <- "rs12126142"
message("snp: ", snp)
plinkr::check_snp(snp)

window_kb <- 1
message("window_kb: ", window_kb)
plinkr::check_window_kb(window_kb)

gcae_experiment_params <- gcaer::read_gcae_experiment_params_file(
  gcae_experiment_params_filename
)

input_data_basename <- "/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1"

if (1 == 2) {
  input_data_basename <- tools::file_path_sans_ext(plinkr::get_plinkr_filename("select_snps.bed"))
}

plink_bin_filenames <- plinkr::create_plink_bin_filenames(
  bed_filename = paste0(input_data_basename, ".bed"),
  bim_filename = paste0(input_data_basename, ".bim"),
  fam_filename = paste0(input_data_basename, ".fam")
)

selected_plink_bin_data <- plinkr::select_snps(
  data = plink_bin_filenames,
  snp_selector = plinkr::create_snp_window_selector(
    snp = snps,
    window_kb = window_kb
  )
)
testthat::expect_true(all(file.exists(unlist(plink_bin_filenames))))

base_output_filename <- paste0(
  gcae_experiment_params$gcae_setup$datadir,
  gcae_experiment_params$gcae_setup$data
)
message("base_output_filename: ", base_output_filename)

plinkr::save_plink_bin_data(
  plink_bin_data = selected_plink_bin_data,
  base_input_filename = base_output_filename
)

message("Done saving PLINK binary data to ", base_output_filename)
