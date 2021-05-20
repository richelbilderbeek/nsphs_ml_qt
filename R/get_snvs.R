#' Get DNA sequences
#' @param n_snvs number of single nucleotide variants
#' @export
get_snvs <- function(n_snvs = 5) {
  testthat::expect_true(n_snvs >= 1)
  tibble::tibble(
    name = paste0("rs", seq_len(n_snvs)),
    position = 2 * seq_len(n_snvs),
    common = "A",
    major = "C"
  )
}
