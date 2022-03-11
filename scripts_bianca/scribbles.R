library(ggpmisc)

t <- tibble::tibble(
  x = runif(n = 100),
  y = runif(n = 100)
)
trendline_formula <- y ~ x
ggplot2::ggplot(t, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(
    method = "lm",
    formula = trendline_formula
  ) +
  ggpmisc::stat_poly_eq(
    formula = trendline_formula,
    geom = "label",
    ggplot2::aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
    parse = TRUE,
    position = ggplot2::position_nudge(x = 0.1, y = 0.1)
  )
ggplot2::ggsave("~/richel_issue_146.png", width = 7, height = 7)


fam_filename <- plinkr::get_plinkr_filename("toy_data.fam")
fam_filename <- "data_1/data_1.fam"
fam_table <- plinkr::read_plink_fam_file(fam_filename)
fam_table$fam <- stringr::str_sub(fam_table$id, end = 4)
plinkr::save_fam_table(fam_table = fam_table, fam_filename = fam_filename)

gcae_input_filenames <- list(
  bed_filename = "data_1/data_1.bed",
  bim_filename = "data_1/data_1.bim",
  fam_filename = "data_1/data_1.fam",
  phe_filename = "data_1/data_1.phe",
  labels_filename = "data_1/data_1_labels.csv"
)
gcaer::check_gcae_input_filenames(gcae_input_filenames)
gcaer::summarise_gcae_input_files(gcae_input_filenames)
