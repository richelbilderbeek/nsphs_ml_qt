#' Get the genotype map
#' @param n_people the number of people
#' @param n_snvs the number of single nucleotide variants
#' @export
get_genotype_map <- function(
  n_people = 10,
  n_snvs = 5) {
  testthat::expect_true(n_people >= 1)
  testthat::expect_true(n_snvs >= 1)
  t <- tidyr::expand_grid(
    person_name = paste0("person_", seq_len(n_people)),
    snv_name = paste0("rs", seq_len(n_snvs)),
    allele = 0
  )
  # The ith person its ith SNS is a major allele
  for (i in seq_len(n_people)) {
    n_th_person <- i
    testthat::expect_true(n_th_person >= 1)
    testthat::expect_true(n_th_person <= n_people)
    n_th_snv <- 1 + ((i - 1) %% n_snvs)
    testthat::expect_true(n_th_snv >= 1)
    testthat::expect_true(n_th_snv <= n_snvs)
    index <- ((n_th_person - 1) * n_snvs) + n_th_snv
    testthat::expect_true(index >= 1)
    testthat::expect_true(index <= nrow(t))
    t$allele[index] <- 1
  }
  t
}
