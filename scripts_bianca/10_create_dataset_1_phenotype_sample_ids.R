# Extract the sample IDs from a phenotype file
#
# and saves it to a file named 'sample_ids.txt'
#
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop(
    "Invalid number of arguments: must have 2 parameters: \n",
    " \n",
    "  1. pheno (path to the phenotype file) \n",
    "  2. sample_ids_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

message("Parameters: {", paste0(args, collapse = ", "), "}")

pheno <- args[1]
sample_ids_filename <- args[2]
message("pheno: ", pheno)
message("sample_ids_filename: ", sample_ids_filename)
if (length(pheno) != 1) stop("'pheno' must be 1 element")
if (!file.exists(pheno)) stop("'pheno' must exist. 'pheno' not found at ", pheno)
if (length(sample_ids_filename) != 1) stop("'sample_ids_filename' must be 1 element")

message("Parameters are valid")

sample_ids <- plinkr::get_sample_ids_from_phe_file(phe_filename = pheno)
save_sample_ids(
  sample_ids = sample_ids,
  sample_ids_filename = sample_ids_filename
)

if (!file.exists(sample_ids_filename)) stop("'sample_ids_filename' not created at ", sample_ids_filename)

