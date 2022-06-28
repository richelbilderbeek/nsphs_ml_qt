#' Get the primary cis association for a protein
#' @inheritParams default_params_doc
#' @return a \link[tibble]{tibble}
#' @examples
#' get_primary_signal(protein_name = "IL-6RA")
#' @author Richèl J.C. Bilderbeek
#' @export
get_primary_signal <- function(
  protein_name,
  kierczak_et_al_2022_table_s2_xlsx_filename =
    get_local_kierczak_et_al_2022_table_s2_xlsx_filename(),
  url = get_kierczak_et_al_2022_table_s2_url()
) {
  nsphsmlqt::check_protein_name(protein_name)
  t <- get_kierczak_et_al_2022_table_s2_xlsx(
    kierczak_et_al_2022_table_s2_xlsx_filename = kierczak_et_al_2022_table_s2_xlsx_filename,
    url = url
  )
  t_for_protein <- dplyr::filter(t, Protein == protein_name)
  testthat::expect_true(nrow(t_for_protein) > 0)

  t_cis_for_protein <- dplyr::filter(t_for_protein, Cis_Trans == "Cis")
  testthat::expect_true(nrow(t_cis_for_protein) > 0)

  row_index <- stringr::str_which(
    t_cis_for_protein$X.Primary.Conditional.hit,
    "Primary"
  )
  testthat::expect_equal(length(row_index), 1)
  t_cis_for_protein[row_index, ]
}
