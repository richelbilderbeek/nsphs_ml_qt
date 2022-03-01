test_that("use", {
  gcae_input_filenames <- list(
    bed_filename = "data_1/data_1.bed",
    bim_filename = "data_1/data_1.bim",
    fam_filename = "data_1/data_1.fam",
    phe_filename = "data_1/data_1.phe",
    labels_filename = "data_1/data_1_labels.csv"
  )
  gcae_input_filenames <- list(
    bed_filename = "nsphs_ml_qt/inst/extdata/sim_data_1.bed",
    bim_filename = "nsphs_ml_qt/inst/extdata/sim_data_1.bim",
    fam_filename = "nsphs_ml_qt/inst/extdata/sim_data_1.fam",
    phe_filename = "nsphs_ml_qt/inst/extdata/sim_data_1.phe",
    labels_filename = "nsphs_ml_qt/inst/extdata/sim_data_1_labels.csv"
  )
  gcae_input_filenames <- list(
    bed_filename = system.file("extdata", "sim_data_1.bed", package = "nsphsmlqt"),
    bim_filename = system.file("extdata", "sim_data_1.bim", package = "nsphsmlqt"),
    fam_filename = system.file("extdata", "sim_data_1.fam", package = "nsphsmlqt"),
    phe_filename = system.file("extdata", "sim_data_1.phe", package = "nsphsmlqt"),
    labels_filename = system.file("extdata", "sim_data_1_labels.csv", package = "nsphsmlqt")
  )
  gcaer::check_gcae_input_files(gcae_input_filenames)
  gcaer::summarise_gcae_input_files(gcae_input_filenames)
})
