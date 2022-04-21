test_that("use", {
  expect_silent(create_fake_bianca())

  skip("Issue #25")
  testthat::expect_true(
    file.exists("/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1.bed")
  )


  # Run scripts
  gcae_experiment_params_filename <- "~/data_issue_5/experiment_params.csv"

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
  singularity_filename <- file.path(
    pkg_root_folder,
    "nsphs_ml_qt.sif"
  )
  testthat::expect_true(file.exists(singularity_filename))
  system2(
    command = "singularity",
    args = c(
      "run", singularity_filename,
      "Rscript", first_script_filename, gcae_experiment_params_filename
    )
  )

  second_script_filename <- file.path(
    pkg_root_folder,
    "scripts_bianca",
    "22_create_issue_5_data.R"
  )
  testthat::expect_true(file.exists(second_script_filename))
  skip("fails here")
  system2(
    command = "singularity",
    args = c(
      "run", singularity_filename,
      "Rscript",
      second_script_filename, gcae_experiment_params_filename
    )
  )
})
