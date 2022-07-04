test_that("use", {
  # If running with a simple additive trait, it should
  # not matter much if the phenotype value is -100, 100 or 200.
  #
  base_phenotype_values <- c(-100, 100, 200)
  results_list <- list()
  for (i in seq_along(base_phenotype_values)) {
    message(i)
    base_phenotype_value <- base_phenotype_values[i]
    assoc_qt_data <- plinkr::create_demo_assoc_qt_data(
      n_individuals = 1000,
      traits = plinkr::create_additive_trait(
        mafs = 0.49,
        n_snps = 10,
        base_phenotype_value = base_phenotype_value,
        phenotype_increase = 0.5
      )
    )
    assoc_qt_data$data <- plinkr::convert_plink_text_data_to_plink_bin_data(
      assoc_qt_data$data
    )
    datadir <- paste0(
      file.path(gcaer::get_gcaer_tempfilename(), "issue_61"),
      "/"
    )
    data <- "issue_61_data"
    base_input_filename <- paste0(datadir, data)
    plinkr::save_plink_bin_data(
      plink_bin_data = assoc_qt_data$data,
      base_input_filename = base_input_filename
    )
    plinkr::save_phe_table(
      phe_table = assoc_qt_data$phenotype_data$phe_table,
      phe_filename = paste0(base_input_filename, ".phe")
    )

    gcae_experiment_params <- gcaer::create_gcae_experiment_params(
      gcae_setup = gcaer::create_test_gcae_setup(
        datadir = datadir,
        data = data,
        superpops = "",
        model_id = "M1",
        pheno_model_id = "p1"
      ),
      analyse_epochs = c(500, 750, 1000),
      metrics = ""
    )
    results <- gcaer::do_gcae_experiment(gcae_experiment_params)

    results$nmse_in_time_table$base_phenotype_value <- base_phenotype_value
    results_list[[i]] <- results$nmse_in_time_table
  }
  t <- dplyr::bind_rows(results_list)
  t$base_phenotype_value <- as.factor(t$base_phenotype_value)
  ggplot2::ggplot(
    t,
    ggplot2::aes(x = epoch, y = nmse, color = base_phenotype_value)
  ) + ggplot2::geom_line()

  ggplot2::ggsave("~/issue_61.png", width = 7, height = 7)
})
