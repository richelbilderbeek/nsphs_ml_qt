#
# Create simulated data in inst/extdata
#
#
args <- commandArgs(trailingOnly = TRUE)
if (1 == 2) {
  args <- c(
    file.path(gcaer::get_gcaer_tempfilename(), "issue_127"),
    "1000", # individuals
    "1000"  # random SNPs
  )
}

if (length(args) != 3) {
  stop(
    "Invalid number of arguments: must have 3 parameters: \n",
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

