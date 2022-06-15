# message("Running on: ", uppmaxr::get_where_i_am())

args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  # There is will be
  args <- "~/data_issue_5/experiment_params.csv"

  # Create it
  #gcaer::save_gcae_experiment_params(
  #  gcae_experiment_params = gcaer::create_test_gcae_experiment_params(),
  #  gcae_experiment_params_filename = args[1]
  #)
}

if (length(args) != 1) {
  stop(
    "Invalid number of arguments: must have 1 parameter: \n",
    " \n",
    "  1. gcae_experiment_params_filename \n",
    " \n",
    "Actual number of parameters: ", length(args), " \n",
    "Parameters: {", paste0(args, collapse = ", "), "}"
  )
}

gcae_experiment_params_filename <- args[1]
message("gcae_experiment_params_filename: ", gcae_experiment_params_filename)

# Create the parameter file and dataset for #18
matches <- stringr::str_match(
  gcae_experiment_params_filename,
  "^((.*)(issue_[:digit:]+)/)experiment_params\\.csv"
)
message("matches: \n * ", paste0(matches, collapse = "\n * "))
if (any(is.na(matches))) {
  stop(
    "no matches found for ",
    "'gcae_experiment_params_filename': ", gcae_experiment_params_filename
  )
}
unique_id <- matches[1, 4]
message("unique_id: ", unique_id)
datadir <- matches[1, 2]
message("datadir: ", datadir)
data <- basename(datadir)
message("data: ", data)
trainedmodeldir <- stringr::str_replace(datadir, "/$", "_ae/")
message("trainedmodeldir: ", trainedmodeldir)
base_input_filename <- paste0(datadir, data)
message("base_input_filename: ", base_input_filename)

gcae_setup <- gcaer::create_gcae_setup(
  datadir = datadir,
  data = data,
  superpops = "",
  model_id = "M3d",
  train_opts_id = "ex3",
  data_opts_id = "b_0_4",
  pheno_model_id = "p1",
  trainedmodeldir = trainedmodeldir
)
gcae_options <- gcaer::create_gcae_options(gcae_folder = "/opt/gcae_richel")

gcae_experiment_params <- gcaer::create_gcae_experiment_params(
  gcae_setup = gcae_setup,
  gcae_options = gcae_options,
  analyse_epochs = seq(10, 1000, by = 10),
  metrics = ""
)
gcaer::save_gcae_experiment_params(
  gcae_experiment_params = gcae_experiment_params,
  gcae_experiment_params_filename = gcae_experiment_params_filename
)
message("Saved 'gcae_experiment_params' to ", gcae_experiment_params_filename)

testthat::expect_true(file.exists(gcae_experiment_params_filename))

message("Really saved 'gcae_experiment_params' at ", gcae_experiment_params_filename)
