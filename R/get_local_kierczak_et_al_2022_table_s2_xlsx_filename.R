#' Get the local path where the file downloaded from
#' \link{get_kierczak_et_al_2022_table_s2_url} will be stored.
#' @return the filename
#' @examples
#' get_local_kierczak_et_al_2022_table_s2_xlsx_filename()
#' @author Richèl J.C. Bilderbeek
#' @export
get_local_kierczak_et_al_2022_table_s2_xlsx_filename <- function() { # nolint indeed a long function name
  file.path(rappdirs::app_dir("nsphsmlqt")$data(), "TableS2.xlsx")
}
