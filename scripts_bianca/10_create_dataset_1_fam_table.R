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

if (length(args) != 1) {
  stop(
    "Invalid number of arguments: must have 1 parameter: \n",
    " \n",
    "  1. fam_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}
message("Parameters: {", paste0(args, collapse = ", "), "}")

fam_filename <- args[1]
message("fam_filename: ", fam_filename)
plinkr::check_fam_filename(fam_filename)

message("Parameters are valid")

if (1 == 2) {
  fam_filename <- plinkr::get_plinkr_filename("toy_data.fam")
}
fam_filename <- "data_1/data_1.fam"

message("Reading 'fam_table'")

fam_table <- plinkr::read_plink_fam_file(fam_filename)

message("Set the FID to the first characters of the IID")

fam_table$fam <- stringr::str_sub(fam_table$id, end = 4)

message("Saving 'fam_table' to ", pheno)

plinkr::save_fam_table(fam_table = fam_table, fam_filename = fam_filename)

message("Done saving 'fam_table' to ", pheno)
