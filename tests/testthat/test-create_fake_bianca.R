test_that("use", {
  expect_silent(create_fake_bianca())
  # Run scripts
  pkg_root_folder <- getwd()
  if (stringr::str_detect(pkg_root_folder, "nsphs_ml_qt.tests.testthat$")) {
    pkg_root_folder <- dirname(dirname(pkg_root_folder))
  }
  first_script_filename <- file.path(
    pkg_root_folder,
    "scripts_bianca",
    "21_create_issue_5_params.R"
  )
  testthat::expect_true(file.exists(first_script_filename))
  #jobid_22=$(sbatch -A sens2021565 --dependency=afterok:$jobid_21 --output=22_create_${unique_id}_data.log   ./nsphs_ml_qt/scripts_bianca/22_create_issue_5_data.sh   $gcae_experiment_params_filename | cut -d ' ' -f 4)


})
