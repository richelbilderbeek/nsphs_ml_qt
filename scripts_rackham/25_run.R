message("Running on: ", uppmaxr::get_where_i_am())

args <- commandArgs(trailingOnly = TRUE)

if (1 == 2) {
  args <- "~/sim_data_issue_18/experiment_params.csv"
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
testthat::expect_true(file.exists(gcae_experiment_params_filename))

gcae_experiment_params <- gcaer::read_gcae_experiment_params_file(
  gcae_experiment_params_filename = gcae_experiment_params_filename
)

message("Running the GCAE experiment")
gcae_experiment_results <- gcaer::do_gcae_experiment(
  gcae_experiment_params = gcae_experiment_params
)

message("Save the GCAE experiment results")
gcaer::save_gcae_experiment_results(
  gcae_experiment_results = gcae_experiment_results,
  folder_name = gcae_experiment_params$gcae_setup$trainedmodeldir
)

message("Create the GCAE experiment results' plots")
gcaer::create_plots_from_gcae_experiment_results(
  folder_name = gcae_experiment_params$gcae_setup$trainedmodeldir
)

