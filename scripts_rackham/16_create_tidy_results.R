#
# Create two files:
#
# Filename                             |Copy on Bianca?|Copy on Rackham?
# -------------------------------------|---------------|----------------
# tidy_data/full/results.csv           |No             |Yes
# tidy_data/depersonalized/results.csv |Yes            |Yes
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

datadir <- args[1]
trainedmodeldir <- args[2]
unique_id <- args[3]

message("datadir: ", datadir)
message("trainedmodeldir: ", trainedmodeldir)
message("unique_id: ", unique_id)

gcaer::check_datadir(datadir)
gcaer::check_trainedmodeldir(trainedmodeldir)
if (length(unique_id) != 1) stop("'unique_id' must be 1 element")

message("Parameters are valid")

message("Start analysis")
analysis_filenames <- gcaer::analyse_qt_prediction(
  datadir = datadir,
  trainedmodeldir = trainedmodeldir,
  unique_id = unique_id
)
message("Created files: ", paste0(analysis_filenames, collapse = ", "))

message("End of analysis")
