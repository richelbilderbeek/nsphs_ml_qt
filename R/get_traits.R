#' Get DNA sequences
#' @param n_people the number of people
#' @export
get_traits <- function(n_people = 10) {
  testthat::expect_true(n_people >= 1)
  tibble::tibble(
    name = paste0("person_", seq_len(n_people)),
    trait_a = runif(n = n_people),
    trait_b = runif(n = n_people)
  )
}
