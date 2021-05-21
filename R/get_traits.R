#' Get DNA sequences
#' @param n_people the number of people
#' @export
get_traits <- function(n_people = 10) {
  testthat::expect_true(n_people >= 1)
  tibble::tibble(
    name = paste0("person_", seq_len(n_people)),
    trait_a = seq_len(n_people),
    trait_b = seq_len(n_people) * seq_len(n_people),
    trait_c = seq_len(n_people) * seq_len(n_people) * seq_len(n_people),
    trait_d = sin(seq_len(n_people))
  )
}
