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

# IL6RA, from stringr::str_subset(colnames(nsphsr::create_pea_1()), "IL6RA")
# CVD3_142_IL-6RA, from stringr::str_subset(colnames(nsphsr::create_pea_3()), "IL-6RA")
# IL-6RA is reported in Hoeglund et al (from panel position CVD3_142), so use that one
protein_name <- "CVD3_142_IL-6RA"
message("protein_name: ", protein_name)

# Where the data is loaded from
input_data_basename <- "/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1"
if (1 == 2) {
  input_data_basename <- tools::file_path_sans_ext(plinkr::get_plinkr_filename("select_snps.bed"))
}

# Where the files will be saved to
gcae_experiment_params <- gcaer::read_gcae_experiment_params_file(
  gcae_experiment_params_filename
)
base_output_filename <- paste0(
  gcae_experiment_params$gcae_setup$datadir,
  gcae_experiment_params$gcae_setup$data
)
message("base_output_filename: ", base_output_filename)
plink_bin_filenames <- plinkr::create_plink_bin_filenames(
  bed_filename = paste0(input_data_basename, ".bed"),
  bim_filename = paste0(input_data_basename, ".bim"),
  fam_filename = paste0(input_data_basename, ".fam")
)
labels_filename <- paste0(base_output_filename, "_labels.csv")
message("labels_filename: ", labels_filename)
gcaer::check_csv_filename(labels_filename)
phe_filename <- paste0(base_output_filename, ".phe")
message("phe_filename: ", phe_filename)
plinkr::check_phe_filename(phe_filename)

message("#####################################################################")
message("1. Select the SNPs")
message("#####################################################################")

selected_plink_bin_data <- plinkr::select_snps(
  data = plink_bin_filenames,
  snp_selector = plinkr::create_snp_window_selector(
    snp = snp,
    window_kb = window_kb
  )
)
testthat::expect_true(all(file.exists(unlist(plink_bin_filenames))))

plinkr::save_plink_bin_data(
  plink_bin_data = selected_plink_bin_data,
  base_input_filename = base_output_filename
)

message("Done saving PLINK binary data to ", base_output_filename)

message("#####################################################################")
message("2. Select the phenotypes")
message("#####################################################################")

cur_wd <- getwd()
setwd("/proj/sens2021565/nobackup/NSPHS_data/")
load("pea_1_2.rntransformed.AJ.RData")
load("pea3.rntransformed.RData")
setwd(cur_wd)

message("Picking the table to use")
raw_table <- pea_3
if (1 == 2) {
  raw_table <- nsphsr::create_pea_3()
}

message("Protein name '", protein_name, "' must be present in the table")
testthat::expect_true(protein_name %in% colnames(raw_table))
column_index <- which(colnames(raw_table) == protein_name)
testthat::expect_equal(1, length(column_index))

message("Creating unsorted 'phe_table'")
unsorted_phe_table <- tibble::tibble(
  FID = stringr::str_sub(rownames(raw_table), end = 4),
  IID = rownames(raw_table),
  P1 = as.numeric(raw_table[, column_index])
)

message("Creating sorted 'phe_table'")
phe_table <- unsorted_phe_table[order(unsorted_phe_table$IID), ]

message("Set the FID to the first characters of the IID")
phe_table$FID <- stringr::str_sub(phe_table$IID, end = 4)

message("Saving 'phe_table' to ", phe_filename)
plinkr::save_phe_table(
  phe_table = phe_table,
  phe_filename = phe_filename
)
message("Done saving 'phe_table' to ", phe_filename)

message("#####################################################################")
message("3. Create labels")
message("#####################################################################")

phe_table <- plinkr::read_plink_phe_file(phe_filename = phe_filename)

labels_table <- tibble::tibble(
  population = unique(stringr::str_sub(phe_table$IID, end = 4)),
  super_population = "Sweden"
)
gcaer::check_labels_table(labels_table = labels_table)
gcaer::save_labels_table(
  labels_table = labels_table,
  labels_filename = labels_filename
)

message("Done saving 'labels_table' to ", labels_filename)

message("#####################################################################")
message("4. Resize the data")
message("#####################################################################")

gcae_input_filenames <- gcaer::create_gcae_input_filenames(
  bed_filename = plink_bin_filenames$bed_filename,
  bim_filename = plink_bin_filenames$bim_filename,
  fam_filename = plink_bin_filenames$fam_filename,
  phe_filename = phe_filename,
  labels_filename = labels_filename
)
gcaer::check_gcae_input_filenames(gcae_input_filenames)

message("Parameters are valid")

message("Summary before resize")
gcaer::summarise_gcae_input_files(gcae_input_filenames)

message("Start resizing")
gcaer::resize_to_shared_individuals_from_files(
  gcae_input_filenames = gcae_input_filenames
)

message("Summary after resize")
gcaer::summarise_gcae_input_files(gcae_input_filenames)

message("Done resizing the data")
