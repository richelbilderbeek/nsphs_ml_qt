test_that("use", {
  expect_silent(create_sim_data())

  sim_data <- create_sim_data()
  expect_true("genotype" %in% names(sim_data))
  expect_true("phenotype" %in% names(sim_data))
})
