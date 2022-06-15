# message("Running on: ", uppmaxr::get_where_i_am())

args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  # There is will be
  # M0_1n M0_2n M0_3n M0_4n M0_5n M0 M1_1n M1_2n M1_3n M1_4n M1_5n M1 M3d_1n M3d_2n M3d_3n M3d_4n M3d_5n M3d M3e_1n M3e_2n M3e_3n M3e_4n M3e_5n M3e M3f_1n M3f_2n M3f_3n M3f_4n M3f_5n M3f M3j10U_1n M3j10U_2n M3j10U_3n M3j10U_4n M3j10U_5n M3j10U M3j10X_1n M3j10X_2n M3j10X_3n M3j10X_4n M3j10X_5n M3j10X
  args <- "/home/richel/data_issue_42_M0_1n_p1_1/experiment_params.csv"

  # Create it
  gcae_experiment_params <- gcaer::create_test_gcae_experiment_params()
  gcae_experiment_params$gcae_setup$model_id <- "M3d"
  gcae_experiment_params$gcae_setup$pheno_model_id <- "p1"
  gcae_experiment_params$gcae_setup$window_kb <- "1" # 'gcaer::read_gcae_experiment_params_file' reads extra elements as strings
  gcaer::save_gcae_experiment_params(
    gcae_experiment_params,
    gcae_experiment_params_filename = args[1]
  )
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
pattern <- "^((.*)/data_(issue_[:digit:]+_(M.*)_(p[:digit:])_([:digit:]+))/)experiment_params\\.csv"
matches <- stringr::str_match(
  gcae_experiment_params_filename,
  pattern = pattern

)
message("Matches in 'gcae_experiment_params_filename': \n * ", paste0(matches, collapse = "\n * "))
if (any(is.na(matches))) {
  stop(
    "No matches found for GCAE experiment parameters filename. \n",
    "'gcae_experiment_params_filename': ", gcae_experiment_params_filename, " \n",
    "pattern: ", pattern
  )
}
unique_id <- matches[1, 4]
message("unique_id: ", unique_id)
datadir <- matches[1, 2]
message("datadir: ", datadir)
gcaer::check_datadir(datadir)
data <- basename(datadir)
message("data: ", data)
gcaer::check_data(data)
trainedmodeldir <- stringr::str_replace(datadir, "/$", "_ae/")
message("trainedmodeldir: ", trainedmodeldir)
gcaer::check_trainedmodeldir(trainedmodeldir)

model_id <- matches[1, 5]
message("model_id: ", model_id)
gcaer::check_model_id(model_id)

pheno_model_id <- matches[1, 6]
message("pheno_model_id: ", pheno_model_id)
gcaer::check_pheno_model_id(pheno_model_id)

window_kb <- as.numeric(matches[1, 7])
message("window_kb: ", window_kb)
base_input_filename <- paste0(datadir, data)
message("base_input_filename: ", base_input_filename)

gcae_setup <- gcaer::create_gcae_setup(
  datadir = datadir,
  data = data,
  superpops = "",
  model_id = model_id,
  train_opts_id = "ex3",
  data_opts_id = "b_0_4",
  pheno_model_id = pheno_model_id,
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
