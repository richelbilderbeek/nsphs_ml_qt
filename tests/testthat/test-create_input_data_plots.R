test_that("use", {
  skip("#33")
  gcae_experiment_params <- gcaer::create_gcae_experiment_params(
    gcae_options = gcaer::create_gcae_options(),
    gcae_setup = gcaer::create_test_gcae_setup(
      model_id = "M0",
      superpops = "", # no labels
      pheno_model_id = "p0"
    ),
    analyse_epochs = c(1, 2),
    metrics = "" # no metrics
  )

  input_data_plots_filenames <- create_input_data_plots(
    gcae_experiment_params = gcae_experiment_params
  )
  expect_true(
    all(
      file.exists(as.character(unlist(input_data_plots_filenames)))
    )
  )
})
