# Create labels from the phenotype data at file 'pheno'
# and saves it to file 'labels_filename'
#
args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  pheno <- plinkr::get_plinkr_tempfilename(fileext = ".phe")
  labels_filename <- plinkr::get_plinkr_tempfilename(pattern = "labels")
  args <- c(pheno, labels_filename)

  # Create fake phenotype table
  phe_table <- plinkr::get_test_phe_table()
  n_rows <- nrow(phe_table)
  phe_table$FID <- 0
  phe_table$IID <- sample(
    x = paste0(c("KA06-", "KA09-"), seq(1, 1000)),
    size = n_rows,
    replace = FALSE
  )
  plinkr::save_phe_table(phe_table = phe_table, phe_filename = pheno)
}

if (length(args) != 2) {
  stop(
    "Invalid number of arguments: must have 2 parameters: \n",
    " \n",
    "  1. pheno (the .phe filename)\n",
    "  2. labels_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

message("Parameters: {", paste0(args, collapse = ", "), "}")

pheno <- args[1]
labels_filename <- args[2]
message("pheno: ", pheno)
message("labels_filename: ", labels_filename)
plinkr::check_phe_filename(phe_filename = pheno)
if (length(labels_filename) != 1) stop("'labels_filename' must be 1 element")

message("Parameters are valid")

phe_table <- plinkr::read_plink_phe_file(phe_filename = pheno)

labels_table <- tibble::tibble(
  population = stringr::str_sub(phe_table$IID, end = 4),
  super_population = "Sweden"
)
gcaer::check_labels_table(labels_table = labels_table)
gcaer::save_labels_table(
  labels_table = labels_table,
  labels_filename = labels_filename
)

message("Done saving 'labels_table' to ", labels_filename)
