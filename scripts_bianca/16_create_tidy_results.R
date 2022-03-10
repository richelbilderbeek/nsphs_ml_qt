#
# Create two files:
#
# Filename                             |Copy on Bianca?|Copy on Rackham?
# -------------------------------------|---------------|----------------
# tidy_full_data/results.csv           |No             |Yes
# tidy_depersonalized_data/results.csv |Yes            |Yes
#

# Take the actual/known/true phenotypes
# Take the predicted phenotypes

# Full results:
#
# True phenotype | Estimated phenotype | Difference | Individual in training set yes/no
#
# Depersonalized results:
#
# [remove the first two columns]

args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 3) {
  stop(
    "Invalid number of arguments: must have 3 parameters: \n",
    " \n",
    "  1. datadir \n",
    "  2. trainedmodeldir \n",
    "  3. unique_id \n",
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
analysis_filenames <- gcaer::analyse_qt_prediction_depersonalized(
  datadir = datadir,
  trainedmodeldir = trainedmodeldir,
  unique_id = unique_id
)
message("Created files: ", paste0(analysis_filenames, collapse = ", "))

message("End of analysis")

