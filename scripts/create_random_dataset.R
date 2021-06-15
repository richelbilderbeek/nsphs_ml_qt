# Created random dataset, fix #26
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
  ped_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.ped" # nolint indeed a long line
)
plinkr::save_map_table_to_file(
  map_table = assoc_qt_params$map_table,
  map_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.map" # nolint indeed a long line
)
plinkr::save_phenotype_table_to_file(
  phenotype_table = assoc_qt_params$phenotype_table,
  phenotype_filename = "/home/richel/GitHubs/nsphs_ml_qt/inst/extdata/random.phenotype" # nolint indeed a long line
)
