#
# Do a full experiment on Bianca
#
# Usage:
#
# cat scripts/do_experiment.R | ./gcaer_v0.4.sif
#

library(gcaer)


# Location of GCAE in Singularity container
gcae_options <- create_gcae_options(gcae_folder = "/opt/gcaer")
# The genetic data folder
datadir <- "/proj/sens2021565/nobackup/NSPHS_data/"
# 'data' is the base file name
data <- "NSPHS.WGS.hg38.plink1"

# Things for local computer
if (as.character(Sys.info()["nodename"]) == "N141CU") {
  gcae_options <- create_gcae_options()
  datadir <- file.path(
    get_gcae_subfolder(gcae_options = gcae_options),
    "example_tiny/"
  )
  data <- "HumanOrigins249_tiny"
}
# Number of training epochs
epochs <- 3

# Be verbose
message("gcae_options$gcae_folder: ", gcae_options$gcae_folder)
message("gcae_options$gcae_version: ", gcae_options$gcae_version)
message("datadir: ", datadir)
message("data: ", data)
message("epochs: ", epochs)

testthat::expect_true(is_gcae_installed(gcae_options = gcae_options))

fam_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.fam$")
testthat::expect_equal(1, length(fam_filename))

bim_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bim$")
testthat::expect_equal(1, length(bim_filename))

bed_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bed$")
testthat::expect_equal(1, length(bed_filename))

# Create the GCAE setup
gcae_setup <- create_gcae_setup()

# The model ID
model_filename <- get_gcae_model_filename(
  model_id = gcae_setup$model_id,
  gcae_options = gcae_options
)
# train_opts_id
train_opts_filename <- get_gcae_train_opts_filename(
  train_opts_id = gcae_setup$train_opts_id,
  gcae_options = gcae_options
)

# data_opts_id
data_opts_filename <- get_gcae_data_opts_filename(
  data_opts_id = gcae_setup$data_opts_id,
  gcae_options = gcae_options
)

# Show training filenames
message("model_filename :", model_filename)
message("train_opts_filename :", train_opts_filename)
message("data_opts_filename :", data_opts_filename)

testthat::expect_true(file.exists(model_filename))
testthat::expect_true(file.exists(train_opts_filename))
testthat::expect_true(file.exists(data_opts_filename))

# Training
train_filenames <- gcae_train(
  datadir = datadir,
  data = data,
  gcae_setup = gcae_setup,
  epochs = epochs,
  save_interval = 1
)
message("basename(train_filenames): {", paste0(basename(train_filenames), collapse = ", "), "}")

train_results <- parse_train_filenames(train_filenames)

# Training times
ggplot2::ggplot(
  train_results$train_times_table,
  ggplot2::aes(x = epoch, y = train_times_sec)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, NA))
ggplot::ggsave("train_times.png", width = 7, height = 7)

# Losses from training
ggplot2::ggplot(
  train_results$losses_from_train_t_table,
  ggplot2::aes(x = epoch, y = losses_from_train_t)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
ggplot::ggsave("losses_from_train_t.png", width = 7, height = 7)

# Losses from validation
ggplot2::ggplot(
  train_results$losses_from_train_v_table,
  ggplot2::aes(x = epoch, y = losses_from_train_v)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
ggplot::ggsave("losses_from_train_v.png", width = 7, height = 7)

