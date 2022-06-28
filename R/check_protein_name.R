#' Check if the protein name is valid
#'
#' Check if the protein name is valid.
#' Will \link{stop} if not.
#' @inheritParams default_params_doc
#' @return nothing
#' @examples
#' check_protein_name(protein_name = "IL-6RA")
#' @author Richèl J.C. Bilderbeek
#' @export
check_protein_name <- function(
  protein_name,
  kierczak_et_al_2022_table_s2_xlsx_filename =
    get_local_kierczak_et_al_2022_table_s2_xlsx_filename(),
  url = get_kierczak_et_al_2022_table_s2_url()
) {
  testthat::expect_length(protein_name, 1)
  testthat::expect_true(is.character(protein_name))
  testthat::expect_true(nchar(protein_name) > 0)
  t <- nsphsmlqt::get_kierczak_et_al_2022_table_s2_xlsx(
    kierczak_et_al_2022_table_s2_xlsx_filename =
      kierczak_et_al_2022_table_s2_xlsx_filename,
    url = url
  )
  if (!protein_name %in% t$Protein) {
    stop(
      "'protein_name' not found in the list of valid proteins. \n",
      "protein_name: ", protein_name, " \n",
      "Tip: valid protein names are at ",
        "'get_kierczak_et_al_2022_table_s2_xlsx()$Protein'"
    )
  }
  invisible(protein_name)
}
