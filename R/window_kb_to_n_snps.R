#' For a protein and a window, get the number of associations
#'
#' See the vignette `snps_used` for the calculation of these numbers
#' @inheritParams default_params_doc
#' @return the number of associations found for the primary
#' association for the protein within a window of `window_kb` (i.e.
#' half a `window_kb` downstream and half a `window_kb` upstream)
#' @examples
#' window_kb_to_n_associations("IL-17RA", 10) # 4
#' @author Richèl J.C. Bilderbeek
#' @export
window_kb_to_n_associations <- function(
    protein_name,
    window_kb,
    kierczak_et_al_2022_table_s2_xlsx_filename =
      get_local_kierczak_et_al_2022_table_s2_xlsx_filename(),
    url = get_kierczak_et_al_2022_table_s2_url()
) {
  nsphsmlqt::check_protein_name(protein_name)
  plinkr::check_window_kb(window_kb)
  t_primary <- get_primary_signal(
    protein_name = protein_name,
    kierczak_et_al_2022_table_s2_xlsx_filename = kierczak_et_al_2022_table_s2_xlsx_filename,
    url = url
  )
  t <- get_kierczak_et_al_2022_table_s2_xlsx(
    kierczak_et_al_2022_table_s2_xlsx_filename = kierczak_et_al_2022_table_s2_xlsx_filename,
    url = url
  )
  t_for_protein <- dplyr::filter(t, Protein == protein_name)
  t_on_same_chr <- dplyr::filter(t_for_protein, Chr == t_primary$Chr)
  distances <- t_on_same_chr$Position. - t_primary$Position. # nolint Position. is the name as in the submitted table
  sum(abs(distances) < window_kb * 1000 / 2)
}
