#
# Create two files:
#
# Filename                             |Copy on Bianca?|Copy on Rackham?
# -------------------------------------|---------------|----------------
# tidy_data/full/results.csv           |No             |Yes
# tidy_data/depersonalized/results.csv |Yes            |Yes
#

folder <- "~/GitHubs/nsphs_ml_qt/scripts_rackham/logs/20220304_issue_122"

# Take the actual/known/true phenotypes
local_folders <- list.dirs(folder, recursive = FALSE)
message("local_folders: ", paste0(local_folders, collapse = ", "))
results_folder <- stringr::str_subset(local_folders, "_ae$")
message("results_folder: ", results_folder)
testthat::expect_equal(1, length(results_folder))
input_folder <- stringr::str_sub(results_folder, end = -4)
message("input_folder: ", results_folder)
testthat::expect_true(dir.exists(input_folder))

input_phe_filename <- list.files(
  path = input_folder,
  pattern = "\\.phe$",
  full.names = TRUE
)
message("input_phe_filename: ", input_phe_filename)
testthat::expect_equal(length(input_phe_filename), 1)
testthat::expect_true(file.exists(input_phe_filename))
results_phe_filename <- list.files(
  path = results_folder,
  pattern = "\\.phe$",
  full.names = TRUE,
  recursive = TRUE
)
testthat::expect_equal(length(results_phe_filename), 1)
testthat::expect_true(file.exists(results_phe_filename))

# Take the predicted phenotypes
input_phe_table <- plinkr::read_plink_phe_file(input_phe_filename)
message("head(input_phe_table): \n", paste0(knitr::kable(head(input_phe_table)), collapse = "\n"))

results_phe_table <- plinkr::read_plink_phe_file(results_phe_filename)
message("head(results_phe_table): \n", paste0(knitr::kable(head(results_phe_table)), collapse = "\n"))

testthat::expect_equal(
  input_phe_table$FID,
  results_phe_table$FID
)
testthat::expect_equal(
  input_phe_table$IID,
  results_phe_table$IID
)
names(input_phe_table) <- c(
  names(input_phe_table)[-3],
  "true_phenotype"
)
names(results_phe_table) <- c(
  names(results_phe_table)[-3],
  "predicted_phenotype"
)
full_phe_table <- dplyr::full_join(input_phe_table, results_phe_table)

ggplot2::ggplot(
  full_phe_table,
  ggplot2::aes(x = true_phenotype, y = predicted_phenotype)
) + ggplot2::geom_point() +
  ggplot2::geom_abline(slope = 1, lty = "dashed") +
  ggplot2::geom_smooth(method = "lm", se = TRUE, col = "red")
ggplot2::ggsave("~/20220304_issue_122.png", width = 7, height = 7)

