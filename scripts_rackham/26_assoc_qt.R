args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  args <- "~/sim_data_issue_18/experiment_params.csv"
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
testthat::expect_true(file.exists(gcae_experiment_params_filename))

# Create the parameter file and dataset for #18
matches <- stringr::str_match(
  gcae_experiment_params_filename,
  "^((.*)(issue_[:digit:]+)_([:digit:]+)/)experiment_params\\.csv"
)
message("matches: \n * ", paste0(matches, collapse = "\n * "))
if (any(is.na(matches))) {
  stop(
    "no matches found for ",
    "'gcae_experiment_params_filename': ", gcae_experiment_params_filename
  )
}
unique_id <- matches[1, 4]
message("unique_id: ", unique_id)
datadir <- matches[1, 2]
message("datadir: ", datadir)
window_kb <- as.numeric(matches[1, 5])
message("window_kb: ", window_kb)
data <- basename(datadir)
message("data: ", data)
base_input_filename <- paste0(datadir, data)
message("base_input_filename: ", base_input_filename)

bed_filename <- paste0(base_input_filename, ".bed")
message("bed_filename: ", bed_filename)

bim_filename <- paste0(base_input_filename, ".bim")
message("bim_filename: ", bim_filename)

fam_filename <- paste0(base_input_filename, ".fam")
message("fam_filename: ", fam_filename)

phe_filename <- paste0(base_input_filename, ".phe")
message("phe_filename: ", phe_filename)

base_output_filename <- base_input_filename
message("base_output_filename: ", base_output_filename)

plink_optionses <- plinkr::create_plink_optionses(plink_folder = "/opt/plinkr")
plink_options <- plink_optionses[[2]]
message("plink_options$plink_version: ", plink_options$plink_version)
message("plink_options$plink_exe_path: ", plink_options$plink_exe_path)
message("plink_options$os: ", plink_options$os)

message("Do quantitative trait association")
qassoc_filenames <- plinkr::assoc_qt(
  assoc_qt_data = plinkr::create_assoc_qt_data(
    data = plinkr::create_plink_bin_filenames(
      bed_filename = bed_filename,
      bim_filename = bim_filename,
      fam_filename = fam_filename
    ),
    phenotype_data = plinkr::create_phenotype_data_filename(
      phe_filename = phe_filename
    )
  ),
  assoc_qt_params = plinkr::create_assoc_qt_params(
    base_input_filename = base_input_filename,
    base_output_filename = base_output_filename
  ),
  plink_options = plink_options
)
message(
  "qassoc_filenames$qassoc_filenames: \n * ",
  paste0(qassoc_filenames$qassoc_filenames, collapse = "\n * ")
)
message(
  "qassoc_filenames$log_filename: ",
  qassoc_filenames$log_filename
)
