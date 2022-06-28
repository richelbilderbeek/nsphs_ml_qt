#' Get Supplementary Table 2 of Kierczak et al., 2022,
#' which contains the associations found
#' @param kierczak_et_al_2022_table_s2_xlsx_filename name of the file to
#' save the Excel sheet to
#' @param url the URL to download the Excel sheet from
#' @return a \link[tibble]{tibble}
#' @note
#' The article is in pre-print as of 2021. As I predict the publication
#' will be in 2022, I will use that in the function name.
#' Pre-print of article is at URL \url{10.21203/rs.3.rs-625433/v1}
#'
#' This function is slow because of parsing the XLSX file,
#' not because it is downloading every time (because the download is
#' saved locally at
#' \link{get_local_kierczak_et_al_2022_table_s2_xlsx_filename})
#' @examples
#' t <- get_kierczak_et_al_2022_table_s2_xlsx()
#' testthat::expect_true(tibble::is_tibble(t))
#' testthat::expect_equal(478, nrow(t))
#'
#' # From the article:
#' # However, to include as many lead GWAS SNVs and indels as possible in the
#' # conditional SKAT analyses, we first used a liberal significance
#' # threshold of 5x10−8 in the GWAS.
#' alpha <- 5e-8
#' testthat::expect_true(all(t$P.value < alpha))
#'
#' # From the article:
#' # A total of 274 proteins had at least one significant SNV or indel
#' # (217 proteins had any Cis and 107 any Trans) association
#' # (Supplementary Table S2).
#' testthat::expect_equal(274, length(unique(t$Protein)))
#' cis_associations <- dplyr::filter(t, Cis_Trans == "Cis")
#' testthat::expect_equal(217, length(unique(cis_associations$Protein)))
#' trans_associations <- dplyr::filter(t, Cis_Trans == "Trans")
#' testthat::expect_equal(107, length(unique(trans_associations$Protein)))
#'
#' # Most associations are between a protein and multiple spots
#' # on the same gene
#' # How many polygenic associations are there?
#' t <- get_kierczak_et_al_2022_table_s2_xlsx()
#' t_distinct <- dplyr::distinct(dplyr::select(t, Protein, Gene))
#' testthat::expect_equal(275, nrow(t_distinct))
#'
#' # It appears most proteins simply map to their gene.
#' # How similar (in Levenshtein distance, see 'adist' doc)
#' # are the proteins to the genes?
#' #
#' # First remove all the dashes from the names, and more everything uppercase
#' t_distinct_simplified <- t_distinct
#' t_distinct_simplified$Protein <- stringr::str_replace_all(
#'   t_distinct_simplified$Protein, "-", "")
#' t_distinct_simplified$Gene <- stringr::str_replace_all(
#'   t_distinct_simplified$Gene, "-", "")
#' t_distinct_simplified$Protein <- stringr::str_to_upper(
#'   t_distinct_simplified$Protein)
#' t_distinct_simplified$Gene <- stringr::str_to_upper(
#'   t_distinct_simplified$Gene)
#' # 204 proteins map to their exact gene
#' testthat::expect_equal(
#'   204,
#'   sum(t_distinct_simplified$Protein == t_distinct_simplified$Gene)
#' )
#'
#' # Look at the 71 interesting associations
#' # between a protein and a gene with a different name.
#' # Note that these associations are not always interesting,
#' # e.g. the protein 'PROTEINBOC' is associated with the 'BOC' gene
#' t_distinct_interesting <- t_distinct_simplified[
#'   t_distinct_simplified$Protein != t_distinct_simplified$Gene,
#' ]
#' testthat::expect_equal(
#'   71,
#'   nrow(t_distinct_interesting)
#' )
#' @author Richèl J.C. Bilderbeek
#' @export
get_kierczak_et_al_2022_table_s2_xlsx <- function( # nolint indeed a long function name
  kierczak_et_al_2022_table_s2_xlsx_filename =
    get_local_kierczak_et_al_2022_table_s2_xlsx_filename(),
  url = get_kierczak_et_al_2022_table_s2_url(),
  verbose = FALSE
) {
  if (!file.exists(kierczak_et_al_2022_table_s2_xlsx_filename)) {
    if (verbose) {
      message("'kierczak_et_al_2022_table_s2_xlsx_filename' not found")
    }
    dir.create(
      dirname(kierczak_et_al_2022_table_s2_xlsx_filename),
      recursive = TRUE,
      showWarnings = FALSE
    )
    utils::download.file(
      url = url,
      destfile = kierczak_et_al_2022_table_s2_xlsx_filename,
      quiet = TRUE
    )
  } else {
    if (verbose) {
      message("'kierczak_et_al_2022_table_s2_xlsx_filename' already present")
    }
  }
  testthat::expect_true(file.exists(kierczak_et_al_2022_table_s2_xlsx_filename))
  df <- xlsx::read.xlsx(
    kierczak_et_al_2022_table_s2_xlsx_filename,
    sheetIndex = 1,
    startRow = 8
  )
  t <- tibble::as_tibble(df)
  t
}
