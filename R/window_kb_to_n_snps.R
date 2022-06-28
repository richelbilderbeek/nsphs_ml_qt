#' For a protein and a window, get the number of associations
#'
#' See the vignette `snps_used` for the calculation of these numbers
#' @inheritParams default_params_doc
#' @return the number of associations found for the primary
#' association for the protein within a window of `window_kb` (i.e.
#' half a `window_kb` downstream and half a `window_kb` upstream)
#' @examples
#' t <- get_kierczak_et_al_2022_table_s2_xlsx()
#' @author Richèl J.C. Bilderbeek
#' @export
window_kb_to_n_associations <- function(protein_name, window_kb) {
  nsphsmlqt::check_protein_name(protein_name)
  plinkr::check_window_kb(window_kb)
  if (protein_name == "IL-6RA") {
    return(1)
  }
  if (protein_name == "IL-17RA") {
    if (window_kb == 1) return(2)
    if (window_kb == 10) return(5)
    if (window_kb == 100) return(5)
    if (window_kb == 1000) return(6)
    stop("Unknown 'window_kb': ", window_kb)
  }
}
