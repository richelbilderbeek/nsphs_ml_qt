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

test_that("create dataset files", {
  skip("Created random dataset, fix #26")
  if (getwd() != "/home/richel/GitHubs/nsphs_ml_qt") return()
  n_individuals <- 1000
  n_uniform <- 10
  n_normal <- 10
  assoc_qt_params <- create_random_dataset(
    n_individuals = n_individuals,
    n_uniform = n_uniform,
    n_normal = n_normal
  )
  plinkr::save_ped_table_to_file(
    ped_table = assoc_qt_params$ped_table,
    ped_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.ped"
  )
  plinkr::save_map_table_to_file(
    map_table = assoc_qt_params$map_table,
    map_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.map"
  )
  plinkr::save_phenotype_table_to_file(
    phenotype_table = assoc_qt_params$phenotype_table,
    phenotype_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.phenotype"
  )
})
