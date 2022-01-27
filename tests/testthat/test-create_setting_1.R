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
    col_names = FALSE, # GenoCAE does not use column names
    show_col_types = FALSE
  )
  names(labels) <- c("super_population", "population") # Easier to work with

  expect_true(all(labels$super_population == "Global"))
  expect_true(all(labels$population %in% LETTERS[1:3]))

  # The same format as GCAE
  phe_table <- plinkr::read_plink_phe_file(filenames$phe_filename)
  expect_true(all(phe_table$FID %in% LETTERS[1:3]))
  # All FID and IID combinations must be unique
  expect_equal(
    nrow(phe_table),
    nrow(dplyr::distinct(dplyr::select(phe_table, FID, IID)))
  )
  expect_true(all(phe_table$FID %in% LETTERS[1:3]))

  expect_equal(phe_table$FID, plink_bin_data$fam_table$fam)
  expect_equal(as.character(phe_table$IID), plink_bin_data$fam_table$id)

  file.remove(as.character(unlist(filenames)))
})

test_that("match inst/extdata/setting_1", {
  testthat::expect_true(plinkr::is_plink_installed())

  # The original data
  expected_plink_bin_data <- NA
  {
    bed_filename <- system.file("extdata", "setting_1.bed", package = "nsphsmlqt")
    phe_filename <- system.file("extdata", "setting_1.phe", package = "nsphsmlqt")
    labels_filename <- system.file("extdata", "setting_1_labels.csv", package = "nsphsmlqt")
    plink_bin_data <- plinkr::read_plink_bin_data(tools::file_path_sans_ext(bed_filename))
    plink_bin_data$phe_table <- plinkr::read_plink_phe_file(phe_filename)
    plink_bin_data$labels <- readr:::read_csv(labels_filename, show_col_types = FALSE)
    expected_plink_bin_data <- plink_bin_data
  }
  # Re-created data
  created_plink_bin_data <- NA
  {
    filenames <- create_setting_1(tempfile())
    expect_true(all(file.exists((as.character(unlist(filenames))))))
    plink_bin_data <- plinkr::read_plink_bin_data(tools::file_path_sans_ext(filenames$bed_filename))
    plink_bin_data$phe_table <- plinkr::read_plink_phe_file(filenames$phe_filename)
    plink_bin_data$labels <- readr:::read_csv(filenames$labels_filename, show_col_types = FALSE)
    created_plink_bin_data <- plink_bin_data
    file.remove(as.character(unlist(filenames)))
  }
  expect_equal(created_plink_bin_data, expected_plink_bin_data)
})

test_that("use", {
  if (1 == 2) {
    # Re-create the files in inst/extdata
    create_setting_1(
      base_input_filename = "~/GitHubs/nsphs_ml_qt/inst/extdata/setting_1"
    )
  }
})
