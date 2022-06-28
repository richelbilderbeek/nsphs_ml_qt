test_that("use", {
  expect_equal(
    get_local_kierczak_et_al_2022_table_s2_xlsx_filename(),
    file.path(rappdirs::app_dir("nsphsmlqt")$data(), "TableS2.xlsx")
  )
})
