test_that("use", {
  testthat::expect_true(plinkr::is_plink_installed())

  filenames <- create_setting_1()
  base_input_filename <- tools::file_path_sans_ext(filenames$bed_filename)
  plink_bin_data <- plinkr::read_plink_bin_data(base_input_filename = base_input_filename)
  n_snps <- 1
  n_individuals <- 1000
  expect_equal(n_snps, nrow(plink_bin_data$bed_table))
  expect_equal(n_individuals, ncol(plink_bin_data$bed_table))
  expect_equal(n_snps, nrow(plink_bin_data$bim_table))
  expect_equal(n_individuals, nrow(plink_bin_data$fam_table))

  labels <- readr::read_csv(
    filenames$labels_filename,
    show_col_types = FALSE
  )
  expect_true(all(labels$super_population == "Global"))
  expect_true(all(labels$population %in% LETTERS[1:3]))

  skip("WIP")
  expect_silent(plinkr::read_plink_phe_file(filenames$phe_filename))
  phe_table <- plinkr::read_plink_phe_file(filenames$phe_filename)
})
