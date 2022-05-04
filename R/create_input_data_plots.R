#' Create plots about the input/GWAS data
#'
#' Create plots about the input/GWAS data.
#' @inheritParams default_params_doc
#' @return the filenames of the plots produced
#' @author Richèl J.C. Bilderbeek
#' @export
create_input_data_plots <- function(
  gcae_experiment_params
) {
  gcaer::check_gcae_experiment_params(gcae_experiment_params)

  base_filename <- paste0(
    gcae_experiment_params$gcae_setup$datadir,
    gcae_experiment_params$gcae_setup$data
  )
  phe_filename <- paste0(base_filename, ".phe")
  filenames <- list()
  filenames$trait_value_histogram_filename <- file.path(
    gcae_experiment_params$gcae_setup$trainedmodeldir,
    "trait_value_histogram.png"
  )

  dir.create(
    dirname(trait_value_histogram_filename),
    showWarnings = FALSE,
    recursive = TRUE
  )

  phe_table <- plinkr::read_plink_phe_file(phe_filename)
  phenotype_name <- names(phe_table)[3]
  names(phe_table) <- c(names(phe_table)[1:2], "trait_value")

  trait_value_histogram <- ggplot2::ggplot(
    phe_table,
    ggplot2::aes(x = trait_value)
  ) + ggplot2::geom_histogram() +
    ggplot2::scale_x_continuous(name = phenotype_name) +
    gcaer::get_gcaer_theme()
  ggplot2::ggsave(
    plot =  trait_value_histogram,
    filename = filenames$trait_value_histogram_filename,
    width = 7,
    height = 7
  )
  filenames
}
