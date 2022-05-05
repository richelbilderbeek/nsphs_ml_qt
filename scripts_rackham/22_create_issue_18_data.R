# message("Running on: ", uppmaxr::get_where_i_am())

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

message("Reading the GCAE experiment parameters")
                                 
gcae_experiment_params <- gcaer::read_gcae_experiment_params_file(
  gcae_experiment_params_filename = gcae_experiment_params_filename
)

message("Read the GCAE experiment parameters")

base_input_filename <- file.path(
  gcae_experiment_params$gcae_setup$datadir,
  gcae_experiment_params$gcae_setup$data
)

message("base_input_filename: ", base_input_filename)

input_files <- gcaer::create_gcae_input_files_2(
  base_input_filename = base_input_filename,
  n_individuals = 1000,
  n_random_snps = 0
)

message("Created input files: \n * ", paste0(input_files, collapse = "\n * "))

