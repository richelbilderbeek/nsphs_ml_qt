gcae_input_filenames <- list(
  bed_filename = "data_1/data_1.bed",
  bim_filename = "data_1/data_1.bim",
  fam_filename = "data_1/data_1.fam",
  phe_filename = "data_1/data_1.phe",
  labels_filename = "data_1/data_1_labels.csv"
)
gcaer::check_gcae_input_filenames(gcae_input_filenames)
gcaer::summarise_gcae_input_files(gcae_input_filenames)
