
n <- 1000

intercepts_wide <- tibble::tibble(
  est_true = rep(NA, n),
  true_est = rep(NA, n)
)

for (i in seq_len(n)) {
  set.seed(i)
  t <- tibble::tibble(
    true = seq(1, 100),
    estimated = NA
  )
  t$estimated <- t$true + rnorm(n = 100, sd = 1)

  # Way 'est_true': estimated on x, true on y
  r_1 <- lm(formula = true ~ estimated,  t)
  r_1
  intercept_1 <- r_1$coefficients[1]
  intercepts_wide$est_true[i] <- as.numeric(intercept_1)
  ggplot2::ggplot(
    t, ggplot2::aes(x = estimated, y = true)
  ) + ggplot2::geom_point() + ggplot2::geom_smooth(method = "lm") +
    ggpubr::stat_regline_equation(label.y = 400, ggplot2::aes(label = ..eq.label..)) +
    ggpubr::stat_regline_equation(label.y = 350, ggplot2::aes(label = ..rr.label..))


  # Way 'true_est': true on x, estimated on y,
  r_2 <- lm(formula =  estimated ~ true,  t)
  r_2
  intercept_2 <- r_2$coefficients[1]
  intercepts_wide$true_est[i] <- as.numeric(intercept_2)
  ggplot2::ggplot(
    t, ggplot2::aes(x = true, y = estimated)
  ) + ggplot2::geom_point() + ggplot2::geom_smooth(method = "lm") +
    ggpubr::stat_regline_equation(label.y = 400, ggplot2::aes(label = ..eq.label..)) +
    ggpubr::stat_regline_equation(label.y = 350, ggplot2::aes(label = ..rr.label..))

}

intercepts <- tidyr::pivot_longer(data = intercepts_wide, cols = tidyr::everything())

ggplot2::ggplot(intercepts, ggplot2::aes(x = name, y = value)) +
  ggplot2::geom_boxplot()

