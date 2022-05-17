library(gcaer)

gcae_options <- gcaer::create_gcae_options(
  gcae_folder = "/opt/gcae_richel"
)

if (1 == 2) {
  gcae_options <- gcaer::create_gcae_options(gcae_folder = "~/GitHubs/gcae")
}

gcae_experiment_params <- gcaer::create_gcae_experiment_params(
  gcae_options = gcae_options,
  gcae_setup = gcaer::create_test_gcae_setup(
    superpops = "", # no labels
  ),
  analyse_epochs = c(1, 2),
  metrics = "" # no metrics
)

n_models <- length(gcaer::get_gcae_model_ids(gcae_options = gcae_options)) *
  length(gcaer::get_gcae_pheno_model_ids(gcae_options = gcae_options))
message("n_models: ", n_models) # 126

for (model_id in gcaer::get_gcae_model_ids(gcae_options = gcae_options)) {
  for (pheno_model_id in gcaer::get_gcae_pheno_model_ids(gcae_options = gcae_options)) {
    gcae_experiment_params$trainedmodeldir <- paste0(
      normalizePath(
        gcaer::get_gcaer_tempfilename(),
        paste0("test_model_", model_id, "_", pheno_model_id),
        mustWork = FALSE
      ),
      "/"
    )
    gcae_experiment_params$gcae_setup$model_id <- model_id
    gcae_experiment_params$gcae_setup$pheno_model_id <- pheno_model_id

    passes <- FALSE
    tryCatch({
        gcaer::do_gcae_experiment(
          gcae_experiment_params = gcae_experiment_params
        )
        passes <- TRUE
      }, error = function(e) {} # nolint do not care about the braces
    )
    message(paste(date(), model_id, pheno_model_id, passes))
  }
}

