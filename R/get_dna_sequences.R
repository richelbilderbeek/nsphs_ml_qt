#' Get DNA sequences
#' @param n_people the number of people
#' @export
get_dna_sequences <- function(n_people = 10) {
  testthat::expect_true(n_people >= 1)
  nucleotides <- c("A", "C", "G", "T")
  tibble::tibble(
    name = paste0("person_", seq_len(n_people)),
    dna_sequence = replicate(
      n = n_people,
      paste0(sample(x = nucleotides, size = 20, replace = TRUE), collapse = "")
    )
  )
}
