args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  # There is will be
  args <- "~/data_issue_28_10/experiment_params.csv"

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
  "^((.*)(issue_[:digit:]+)_([:digit:]+)/)experiment_params\\.csv"
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
window_kb <- matches[1, 5]
message("window_kb: ", window_kb)
data <- basename(datadir)
message("data: ", data)
base_input_filename <- paste0(datadir, data)
message("base_input_filename: ", base_input_filename)

gcae_setup <- gcaer::create_gcae_setup(
  datadir = datadir,
  data = data,
  superpops = paste0(base_input_filename, "_labels.csv"),
  model_id = "M1",
  train_opts_id = "ex3",
  data_opts_id = "b_0_4",
  pheno_model_id = "p0",
  trainedmodeldir = normalizePath(paste0("~/data_", unique_id ,"_ae/"), mustWork = FALSE)
)
gcae_options <- gcaer::create_gcae_options(gcae_folder = "/opt/gcae_richel")

gcae_experiment_params <- gcaer::create_gcae_experiment_params(
  gcae_setup = gcae_setup,
  gcae_options = gcae_options,
  analyse_epochs = seq(10, 1000, by = 10),
  metrics = "f1_score_3,f1_score_5,f1_score_7,f1_score_9,f1_score_11"
)
gcaer::save_gcae_experiment_params(
  gcae_experiment_params = gcae_experiment_params,
  gcae_experiment_params_filename = gcae_experiment_params_filename
)
message("Saved 'gcae_experiment_params' to ", gcae_experiment_params_filename)

testthat::expect_true(file.exists(gcae_experiment_params_filename))

message("Really saved 'gcae_experiment_params' at ", gcae_experiment_params_filename)
