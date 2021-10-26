#' Get Supplementary Table 1 of Kierczak et al., 2022
#' @note
#' The article is in pre-print as of 2021. As I predict the publication
#' will be in 2022, I will use that in the function name.
#' Pre-print of article is at URL \url{10.21203/rs.3.rs-625433/v1}
#' @param kierczak_et_al_2022_table_s3_xlsx_filename name of the file to
#' save the Excel sheet to
#' @param url the URL to download the Excel sheet from
#' @export
get_kierczak_et_al_2022_table_s3_xlsx <- function(
  kierczak_et_al_2022_table_s3_xlsx_filename = file.path(rappdirs::app_dir("nsphsmlqt")$data(), "TableS3.finalreduced.xlsx"),
  url = "https://assets.researchsquare.com/files/rs-625433/v1/dae8ab58a956bbe10afb47c2.xlsx"
) {
  if(!file.exists(kierczak_et_al_2022_table_s3_xlsx_filename)) {
    dir.create(
      dirname(kierczak_et_al_2022_table_s3_xlsx_filename),
      recursive = TRUE,
      showWarnings = FALSE
    )
    utils::download.file(
      url = url,
      destfile = kierczak_et_al_2022_table_s3_xlsx_filename,
      quiet = TRUE
    )
  }
  testthat::expect_true(file.exists(kierczak_et_al_2022_table_s3_xlsx_filename))
  df <- xlsx::read.xlsx(
    kierczak_et_al_2022_table_s3_xlsx_filename,
    sheetIndex = 1,
    startRow = 6
  )
  t <- tibble::as_tibble(df)
  t
}
