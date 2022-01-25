test_that("use", {
  testthat::expect_true(plinkr::is_plink_installed())

  filenames <- create_setting_1()
  expect_true(all(file.exists((as.character(unlist(filenames))))))

  base_input_filename <- tools::file_path_sans_ext(filenames$bed_filename)
  plink_bin_data <- plinkr::read_plink_bin_data(
    base_input_filename = base_input_filename
  )
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

  # The same as GCAE
  phe_table <- plinkr::read_plink_phe_file(filenames$phe_filename)
  expect_true(all(phe_table$FID %in% LETTERS[1:3]))
  # All FID and IID combinations must be unique
  expect_equal(
    nrow(phe_table),
    nrow(dplyr::distinct(dplyr::select(phe_table, FID, IID)))
  )
  expect_true(all(phe_table$FID %in% LETTERS[1:3]))
  file.remove(as.character(unlist(filenames)))
})
