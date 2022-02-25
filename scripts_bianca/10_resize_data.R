# Resizes the data
#
#
#
args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 5) {
  stop(
    "Invalid number of arguments: must have 2 parameters: \n",
    " \n",
    "  1. bed_filename \n",
    "  2. bim_filename \n",
    "  3. fam_filename \n",
    "  4. phe_filename \n",
    "  5. labels_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

message("Parameters: {", paste0(args, collapse = ", "), "}")

bed_filename <- args[1]
bim_filename <- args[2]
fam_filename <- args[3]
phe_filename <- args[4]
labels_filename <- args[5]

message("bed_filename: ", bed_filename)
message("bim_filename: ", bim_filename)
message("fam_filename: ", fam_filename)
message("phe_filename: ", phe_filename)
message("labels_filename: ", labels_filename)
if (length(bed_filename) != 1) stop("'bed_filename' must be 1 element")
if (length(bim_filename) != 1) stop("'bim_filename' must be 1 element")
plinkr::check_fam_filename(fam_filename)
plinkr::check_phe_filename(phe_filename)
if (length(labels_filename) != 1) stop("'labels_filename' must be 1 element")


gcae_input_filenames <- list(
  bed_filename = bed_filename,
  bim_filename = bim_filename,
  fam_filename = fam_filename,
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
