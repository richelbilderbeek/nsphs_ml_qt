library(ggpmisc)

t <- tibble::tibble(
  x = runif(n = 100),
  y = runif(n = 100)
)
t$x_squared <- t$x ^ 2
t$x_cubed <- t$x ^ 3

trendline_formula_1 <- y ~ x
trendline_formula_2 <- y ~ x_squared + x
trendline_formula_3 <- y ~ x_cubed + x_squared + x
trendline_formulas <- c(
  trendline_formula_1,
  trendline_formula_2,
  trendline_formula_3
)
for (i in seq_along(trendline_formulas)) {
  message(i)
  trendline_formula <- trendline_formulas[[i]]
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
  trendline_model <- lm(data = t, formula = trendline_formula)
  trendline_model

  summary_model <- summary(trendline_model)
  label_str <- paste0(
    "y = ",
    trendline_model$coefficients[1],
    " + ",
    trendline_model$coefficients[2], "x",
    ", R2 = ", summary_model$r.squared
  ); label_str
  message(label_str)
}



broom::tidy(trendline_model)

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
