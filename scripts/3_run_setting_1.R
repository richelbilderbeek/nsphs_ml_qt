#
# Do a full experiment on Bianca
#
# Usage:
#
# cat scripts/2_do_short_experiment.R | ./gcaer.sif
#

library(gcaer)

# The 'gcae_folder' is where the GCAE scripts can be read,
# and where the results are written (as GCAE also manages the
# data). On Bianca, this must, for example,
# be a folder within the home folder.
gcae_folder <- "~/GenoCAE"

# The 'ormr_folder_name' is a folder where all the Python packages
# are already installed by the Singularity container script
ormr_folder_name <- "/opt/ormr"

gcae_options <- create_gcae_options(
  gcae_folder = gcae_folder,
  ormr_folder_name = ormr_folder_name
)
# The genetic data folder
datadir <- "/proj/sens2021565/nobackup/NSPHS_data/"
# 'data' is the base file name
data <- "NSPHS.WGS.hg38.plink1"

# Number of training epochs
epochs <- 3

# Be verbose
message("gcae_options$gcae_folder: ", gcae_options$gcae_folder)
message("gcae_options$gcae_version: ", gcae_options$gcae_version)
message("datadir: ", datadir)
message("data: ", data)
message("epochs: ", epochs)

message("is_gcae_installed (at '", gcae_options$gcae_folder, "'): ", is_gcae_installed(gcae_options = gcae_options))

fam_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.fam$")
message(".fam files found: ", paste(fam_filename, collapse = ", "))

bim_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bim$")
message(".bim files found: ", paste(bim_filename, collapse = ", "))

bed_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.bed$")
message(".bed files found: ", paste(bed_filename, collapse = ", "))

phe_filename <- list.files(datadir, full.names = TRUE, pattern = "\\.phe$")
message(".phe files found: ", paste(phe_filename, collapse = ", "))

# Create the GCAE setup
gcae_setup <- create_gcae_setup(
  datadir = datadir,
  data = data,
  model_id = "M1",
  train_opts_id = "ex3",
  data_opts_id = "b_0_4",
  trainedmodelname = "ae_out",
  pheno_model_id = "p1"
)

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

message("model_filename exists: ", file.exists(model_filename))
message("train_opts_filename exists: ", file.exists(train_opts_filename))
message("data_opts_filename exists: ", file.exists(data_opts_filename))

# Training
train_filenames <- gcae_train(
  gcae_setup = gcae_setup,
  epochs = epochs,
  gcae_options = gcae_options,
  save_interval = 1,
  verbose = TRUE
)
message("basename(train_filenames): {", paste0(basename(train_filenames), collapse = ", "), "}")

train_results <- parse_train_filenames(train_filenames)

# Training times
ggplot2::ggplot(
  train_results$train_times_table,
  ggplot2::aes(x = epoch, y = train_times_sec)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, NA))
ggplot2::ggsave("train_times.png", width = 7, height = 7)

# Losses from training
ggplot2::ggplot(
  train_results$losses_from_train_t_table,
  ggplot2::aes(x = epoch, y = losses_from_train_t)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
ggplot2::ggsave("losses_from_train_t.png", width = 7, height = 7)

# Losses from validation
ggplot2::ggplot(
  train_results$losses_from_train_v_table,
  ggplot2::aes(x = epoch, y = losses_from_train_v)
) + ggplot2::geom_line() +
  ggplot2::scale_y_continuous(limits = c(0.0, 1.0))
ggplot2::ggsave("losses_from_train_v.png", width = 7, height = 7)

