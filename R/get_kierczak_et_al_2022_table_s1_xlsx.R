#' Get Supplementary Table 1 of Kierczak et al., 2022,
#' which links the 414 proteins to their gene and OLink panel
#'
#' Quote from text: 'In this study, we have analysed SNVs and indels,
#' identified by deep coverage WGS, in relation to the protein expression
#' levels of 414 plasma proteins'
#' @note
#' The article is in pre-print as of 2021. As I predict the publication
#' will be in 2022, I will use that in the function name.
#' Pre-print of article is at URL \url{10.21203/rs.3.rs-625433/v1}
#'
#' Also, the protein `IL-12B` is present twice, as it is detected by
#' panels `INF_157_IL-12B` and `NEU_186_IL-12B`
#' @param kierczak_et_al_2022_table_s1_xlsx_filename name of the file to
#' save the Excel sheet to
#' @param url the URL to download the Excel sheet from
#' @export
get_kierczak_et_al_2022_table_s1_xlsx <- function(
  kierczak_et_al_2022_table_s1_xlsx_filename = file.path(rappdirs::app_dir("nsphsmlqt")$data(), "TableS1.xlsx"),
  url = "https://assets.researchsquare.com/files/rs-625433/v1/58f8efdc8eed0b5b5f177ded.xlsx"
) {
  if(!file.exists(kierczak_et_al_2022_table_s1_xlsx_filename)) {
    dir.create(
      dirname(kierczak_et_al_2022_table_s1_xlsx_filename),
      recursive = TRUE,
      showWarnings = FALSE
    )
    utils::download.file(
      url = url,
      destfile = kierczak_et_al_2022_table_s1_xlsx_filename,
      quiet = TRUE
    )
  }
  testthat::expect_true(file.exists(kierczak_et_al_2022_table_s1_xlsx_filename))
  df <- xlsx::read.xlsx(
    kierczak_et_al_2022_table_s1_xlsx_filename,
    sheetIndex = 1,
    startRow = 4
  )
  t <- tibble::as_tibble(df)
  t
}
