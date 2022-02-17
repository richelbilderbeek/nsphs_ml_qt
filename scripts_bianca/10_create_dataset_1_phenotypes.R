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
if (length(args) != 2) {
  stop(
    "Invalid number of arguments: must have 2 parameters: \n",
    " \n",
    "  1. pheno \n",
    "  2. column_index \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

message("Parameters: {", paste0(args, collapse = ", "), "}")

pheno <- args[1]
column_index <- as.numeric(args[2])
message("pheno: ", pheno)
message("column_index: ", column_index)
testthat::expect_equal(length(pheno), 1)
testthat::expect_equal(length(column_index), 1)
testthat::expect_true(column_index >= 1)

message("Parameters are valid")

setwd("/proj/sens2021565/nobackup/NSPHS_data/")

message("getwd(): ", getwd())

load("pea_1_2.rntransformed.AJ.RData")

message("Creating phe_table")

phe_table <- data.frame(FID = rownames(pea_1), IID = rownames(pea_1), P1 = as.numeric(pea_1[, column_index]))

message("Saving phe_table")

write.table(x = phe_table, file = pheno, quote = FALSE, sep = "\t", row.names = FALSE)

message("Done saving phe_table")

