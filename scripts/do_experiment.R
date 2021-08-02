#
# Do a full experiment
#
# Usage:
#
# cat scripts/train.R | ./gcaer
#
#

library(gcaer)
testthat::expect_true(is_gcae_installed())

gcae_options <- create_gcae_options()

# The genetic data
datadir <- file.path(
  get_gcae_subfolder(gcae_options = gcae_options),
  "example_tiny/"
)

# 'data' is the base file name
data <- "HumanOrigins249_tiny"
list.files(datadir, pattern = data)

fam_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.fam$")
testthat::expect_equals(1, length(fam_filename))

bim_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bim$")
testthat::expect_equals(1, length(bim_filename))

bed_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bed$")
testthat::expect_equals(1, length(bed_filename))

# See the GCAE setup
gcae_setup <- create_gcae_setup()

# The model ID
model_filename <- get_gcae_model_filename(gcae_setup$model_id)
testthat::expect_true(file.exists(model_filename))

# train_opts_id
train_opts_filename <- get_gcae_train_opts_filename(gcae_setup$train_opts_id)
testthat::expect_true(file.exists(train_opts_filename))

# data_opts_id
data_opts_filename <- get_gcae_data_opts_filename(gcae_setup$data_opts_id)
testthat::expect_true(file.exists(data_opts_filename))

# Training

epochs <- 3
train_filenames <- gcae_train(
  datadir = datadir,
  data = data,
  gcae_setup = gcae_setup,
  epochs = epochs,
  save_interval = 1
)

train_results <- parse_train_filenames(train_filenames)

# Training times
ggplot2::ggplot(
  train_results$train_times_table,
  ggplot2::aes(x = epoch, y = train_times_sec)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
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

