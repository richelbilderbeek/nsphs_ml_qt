#' This function does nothing. It is intended to inherit is parameters'
#' documentation.
#'
#' @param gcae_experiment_params parameters to run a full
#' `GCAE` experimenr (i.e. call \link[gcaer]{do_gcae_experiment}),
#' as created by \link[gcaer]{create_gcae_experiment_params} and checked
#' by \link[gcaer]{check_gcae_experiment_params}
#' @param verbose the verbosity of a function.
#' Set to \link{TRUE} for more output.
#' Use \link[plinkr]{check_verbose} to detect if this argument is valid.
#' @author Richèl J.C. Bilderbeek
#' @note This is an internal function, so it should be marked with
#'   \code{@noRd}. This is not done, as this will disallow all
#'   functions to find the documentation parameters
default_params_doc <- function(
  gcae_experiment_params,
  verbose
) {
  # Nothing
}
