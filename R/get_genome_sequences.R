#' Get the genome sequences
#' @param n_people the number of people
#' @param sequence_length the DNA sequence length
#' @export
get_genome_sequences <- function(
  n_people = 10,
  sequence_length = 20
) {
  testthat::expect_true(n_people >= 1)
  testthat::expect_true(sequence_length >= 1)
  t <- tibble::tibble(
    person_name = paste0("person_", seq_len(n_people)),
    sequence = paste0(rep("A", sequence_length), collapse = "")
  )
  # Add C's on the diagonal
  for (i in seq_len(n_people)) {
    n_th_person <- i
    testthat::expect_true(n_th_person >= 1)
    testthat::expect_true(n_th_person <= n_people)
    pos <- 1 + ((i - 1) %% sequence_length)
    testthat::expect_true(pos >= 1)
    testthat::expect_true(pos <= nchar(t$sequence[n_th_person]))
    substr(t$sequence[n_th_person], pos, pos) <- "C"
  }
  # Add Gs on a diagonal that goes down twice as fast
  for (i in seq_len(n_people)) {
    n_th_person <- i
    testthat::expect_true(n_th_person >= 1)
    testthat::expect_true(n_th_person <= n_people)
    pos <- 1 + (((i - 1) / 2 ) %% sequence_length)
    testthat::expect_true(pos >= 1)
    testthat::expect_true(pos <= nchar(t$sequence[n_th_person]))
    substr(t$sequence[n_th_person], pos, pos) <- "G"
  }
  # Add Ts on a diagonal that goes down twice as slow
  for (i in seq_len(n_people)) {
    n_th_person <- i
    testthat::expect_true(n_th_person >= 1)
    testthat::expect_true(n_th_person <= n_people)
    pos <- 1 + (((i - 1) * 2 ) %% sequence_length)
    testthat::expect_true(pos >= 1)
    testthat::expect_true(pos <= nchar(t$sequence[n_th_person]))
    substr(t$sequence[n_th_person], pos, pos) <- "T"
  }
  t
}
