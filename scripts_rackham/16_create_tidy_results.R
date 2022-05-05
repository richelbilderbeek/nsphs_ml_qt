message("Running on: ", uppmaxr::get_where_i_am())

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

png_filename <- file.path(trainedmodeldir, paste0(unique_id, ".png"))
csv_filename_for_nmse <- file.path(trainedmodeldir, paste0(unique_id, "_nmse.csv"))

message("png_filename: ", png_filename)
message("csv_filename_for_nmse: ", csv_filename_for_nmse)

message("Start analysis")

gcaer::analyse_qt_prediction(
  datadir = datadir,
  trainedmodeldir = trainedmodeldir,
  png_filename = png_filename,
  csv_filename_for_nmse = csv_filename_for_nmse
)

message("End of analysis")
