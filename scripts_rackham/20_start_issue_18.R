# Create the parameter file and dataset for #18
unique_id <- "issue_18"
datadir <- paste0("~/sim_data_", unique_id, "/")
data <- paste0("sim_data_", unique_id)
base_input_filename <- paste0(datadir, data)
gcae_experiment_params_filename <- paste0(datadir, "experiment_params.csv")
gcae_setup <- gcaer::create_test_gcae_setup(
  datadir = datadir,
  data = data,
  superpops = paste0(base_input_filename, "_labels.csv"),
  model_id = "M1",
  train_opts_id = "ex3",
  data_opts_id = "b_0_4",
  pheno_model_id = "p0",
  trainedmodeldir = paste0("~/sim_data_", unique_id ,"_ae/")
)
gcae_options <- gcaer::create_gcae_options(gcae_folder = "/opt/gcae")

gcae_experiment_params <- gcaer::create_gcae_experiment_params(
  gcae_setup = gcae_setup,
  gcae_options = gcae_options,
  analyse_epochs = seq(10, 100, by = 10),
  metrics = "f1_score_3,f1_score_5"
)
gcaer::save_gcae_experiment_params(
  gcae_experiment_params = gcae_experiment_params,
  gcae_experiment_params_filename = gcae_experiment_params_filename
)
message("Saved 'gcae_experiment_params' to ", gcae_experiment_params_filename)
input_files <- gcaer::create_gcae_input_files_2(
  base_input_filename = base_input_filename,
  n_individuals = 1000,
  n_random_snps = 0
)
message("Created input files at:\n", paste0(input_files, collapse = "\n"))
