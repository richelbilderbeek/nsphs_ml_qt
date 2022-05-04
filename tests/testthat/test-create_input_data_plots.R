test_that("use", {
  skip("#33")
  input_data_plots_filenames <- create_input_data_plots(
    gcae_experiment_params = gcaer::create_test_gcae_experiment_params()
  )
  expect_true(
    all(
      file.exists(as.character(unlist(input_data_plots_filenames)))
    )
  )
})
