#' Create setting 1 for GCAE
#'
#' * Date: 2022-01-17
#' * Goal: do the simplest useful simulation possible
#' * Hypothesis: on the dimensionality reduction plots,
#'   there will be three points.
#'   With 'points' I really mean points, i.e. not clusters,
#'   as there are exactly 3 genotypes
#' * n = 1000
#'
#' Genotype|Phenotype|Allele frequency|Population|Superpopulation
#' --------|---------|----------------|----------|---------------
#' AA      |0        |25%             |A         |Global
#' AC      |50       |50%             |B         |Global
#' CC      |100      |25%             |C         |Global
#'
#' @param base_input_filename base filename of the files to be created
#' @return a \link{list} with the following elements:
#'   * `bed_filename`: contains path to the `.bed` file
#'   * `bim_filename`: contains path to the `.bim` file
#'   * `fam_filename`: contains path to the `.fam` file
#'   * `phe_filename`: contains path to the `.phe` file
#'   * `labels_filename`: contains path to the file with the labels
#' @examples
#' # Create the files
#' filenames <- create_setting_1()
#'
#' # Clean up
#' file.remove(as.character(unlist(filenames)))
#' @author Richèl J.C. Bilderbeek
#' @export
create_setting_1 <- function(base_input_filename = "setting_1") {
  set.seed(1)
  n_individuals <- 1000 # as NSPHS
  assoc_qt_data <- plinkr::create_demo_assoc_qt_data(
    n_individuals = n_individuals,
    traits = plinkr::create_additive_trait(
      mafs = 0.499999,
      base_phenotype_value = 0,
      phenotype_increase = 50
    )
  )

  # Set populations
  is_a <- assoc_qt_data$phenotype_data$phe_table$additive == 0
  is_b <- assoc_qt_data$phenotype_data$phe_table$additive == 50
  is_c <- assoc_qt_data$phenotype_data$phe_table$additive == 100
  testthat::expect_equal(sum(is_a), 242)
  testthat::expect_equal(sum(is_b), 516)
  testthat::expect_equal(sum(is_c), 242)
  testthat::expect_equal(sum(is_a) + sum(is_b) + sum(is_c), n_individuals)
  assoc_qt_data$phenotype_data$phe_table$FID[is_a] <- "A"
  assoc_qt_data$phenotype_data$phe_table$FID[is_b] <- "B"
  assoc_qt_data$phenotype_data$phe_table$FID[is_c] <- "C"
  assoc_qt_data$phenotype_data$phe_table$IID <- seq(1, n_individuals) # nolint follow PLINK convention to use upppercase

  assoc_qt_data$data <- plinkr::convert_plink_text_data_to_plink_bin_data(
    plink_text_data = assoc_qt_data$data
  )
  filenames <- plinkr::save_plink_bin_data(
    plink_bin_data = assoc_qt_data$data,
    base_input_filename = base_input_filename
  )
  phe_filename <- paste0(base_input_filename, ".phe")
  labels_filename <- paste0(base_input_filename, "_labels.csv")
  plinkr::save_phe_table(
    phe_table = assoc_qt_data$phenotype_data$phe_table,
    phe_filename = phe_filename
  )
  filenames$phe_filename <- phe_filename
  labels <- tibble::tribble(
    ~super_population, ~population,
    "Global", "A",
    "Global", "B",
    "Global", "C"
  )
  readr::write_csv(x = labels, file = labels_filename)
  filenames$labels_filename <- labels_filename
  filenames
}
