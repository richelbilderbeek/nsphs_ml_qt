#
# Create simulated data in inst/extdata
#
#
args <- commandArgs(trailingOnly = TRUE)
if (1 == 2) {
  args <- c(
    file.path(gcaer::get_gcaer_tempfilename(), "issue_127"),
    "1000",
    "999"
  )
}

if (length(args) != 3) {
  stop(
    "Invalid number of arguments: must have 4 parameters: \n",
    " \n",
    "  1. base_input_filename \n",
    "  2. n_individuals \n",
    "  3. n_random_snps \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

base_input_filename <- args[1]
n_individuals <- as.numeric(args[2])
n_random_snps <- as.numeric(args[3])

message("base_input_filename: ", base_input_filename)
message("n_individuals: ", n_individuals)
message("n_random_snps: ", n_random_snps)

gcae_input_filesnames <- gcaer::create_gcae_input_files_2(
  base_input_filename = base_input_filename,
  n_individuals = n_individuals,
  n_random_snps = n_random_snps
)
bed_table <- plinkr::read_plink_bed_file_from_files(
  bed_filename = gcae_input_filesnames$bed_filename,
  bim_filename = gcae_input_filesnames$bim_filename,
  fam_filename = gcae_input_filesnames$fam_filename
)
phe_table <- plinkr::read_plink_phe_file(gcae_input_filesnames$phe_filename)
phe_table$additive <- as.numeric(bed_table[1, ]) * pi
plinkr::save_phe_table(
  phe_table = phe_table,
  phe_filename = gcae_input_filesnames$phe_filename
)

data <- plinkr::create_plink_bin_filenames(
  bed_filename = gcae_input_filesnames$bed_filename,
  bim_filename = gcae_input_filesnames$bim_filename,
  fam_filename = gcae_input_filesnames$fam_filename
)

FIX THIS
plinkr::assoc_qt(
  assoc_qt_data = plinkr::create_assoc_qt_data(
    data = data,
    phenotype_data = plinkr::create_phenotype_data_filename(
      phe_filename = gcae_input_filesnames$phe_filename
    )
  ),
  assoc_qt_params = plinkr::create_assoc_qt_params(
    data = data,
    phe_table = phe_table
  )
)
