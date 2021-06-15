#' Create the \code{random} dataset, as described at
#' \url{https://github.com/AJResearchGroup/article_nsphs_ml_qt}
#' @param n_individuals number of individuals to simulate
#' @param n_uniform number of traits with a random uniform
#'   distribution to simulate
#' @param n_normal number of traits with a random normal
#'   distribution to simulate
#' @return an \code{assoc_qt_params} as
#' created by \link[plinkr]{create_demo_assoc_qt_params}
#' @export
create_random_dataset <- function(
  n_individuals,
  n_uniform,
  n_normal
) {
  random_uniform_trait <- plinkr::create_custom_trait(
    calc_phenotype_function = function(snvs) {
      stats::runif(n = nrow(snvs))
    },
    n_snps = 1,
    mafs = 0.49
  )
  random_normal_trait <- plinkr::create_custom_trait(
    calc_phenotype_function = function(snvs) {
      stats::rnorm(n = nrow(snvs))
    },
    n_snps = 1,
    mafs = 0.49
  )

  assoc_qt_params <- plinkr::create_demo_assoc_qt_params(
    n_individuals = n_individuals,
    traits = c(
      rep(list(random_uniform_trait), n_uniform),
      rep(list(random_normal_trait), n_normal)
    )
  )
  names(assoc_qt_params$phenotype_table) <- c(
    names(assoc_qt_params$phenotype_table)[1:2],
    paste0("uniform_", seq(1, n_uniform)),
    paste0("normal_", seq(1, n_normal))
  )
  assoc_qt_params
}
