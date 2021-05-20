#' Get the reference genome sequence
#' @param n_nucleotides the length of the sequences, in the
#'   number of nucleotides
#' @export
get_reference_genome_sequence <- function(n_nucleotides = 20) {
  testthat::expect_true(n_nucleotides >= 1)
  paste0(rep("A", n_nucleotides), collapse = "")
}
