# Create subset 1 from the data
#
# Extracts the first phenotype, Adrenomedullin, from
#
# /proj/sens2021565/nobackup/NSPHS_data/pea_1_2.rntransformed.AJ.RData
#
# and saves it as ~/data_1/adrenomedullin.phe
#
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop(
    "Invalid number of arguments: must have 1 parameters: \n",
    " \n",
    "  1. full_data_phe_filename \n",
    "  2. column_index \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}
full_data_phe_filename <- args[1]
column_index <- as.numeric(args[2])
message("full_data_phe_filename: ", full_data_phe_filename)
message("column_index: ", column_index)
testthat::expect_equal(length(full_data_phe_filename), 1)
testthat::expect_equal(length(column_index), 1)
testthat::expect_true(column_index >= 1)

setwd("/proj/sens2021565/nobackup/NSPHS_data/")
load("pea_1_2.rntransformed.AJ.RData")
phe_table <- data.frame(FID = rownames(pea_1), IID = rownames(pea_1), P1 = as.numeric(pea_1[, column_index]))
write.table(x = phe_table, file = full_data_phe_filename, quote = FALSE, sep = "\t", row.names = FALSE)

