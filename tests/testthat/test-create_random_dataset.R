test_that("use", {
  n_individuals <- 3
  n_uniform <- 4
  n_normal <- 5
  assoc_qt_params <- create_random_dataset(
    n_individuals = n_individuals,
    n_uniform = n_uniform,
    n_normal = n_normal
  )
  expect_equal(n_individuals, nrow(assoc_qt_params$ped_table))
  expect_equal(
    6 + (2 * (n_uniform + n_normal)),
    ncol(assoc_qt_params$ped_table)
  )
  expect_equal(4, ncol(assoc_qt_params$map_table))
  expect_equal(
    n_uniform + n_normal,
    nrow(assoc_qt_params$map_table)
  )
  expect_equal(
    n_individuals,
    nrow(assoc_qt_params$phenotype_table)
  )
  expect_equal(
    2 + n_uniform + n_normal,
    ncol(assoc_qt_params$phenotype_table)
  )
})
