test_that("use", {
  expect_silent(get_kierczak_et_al_2022_table_s3_xlsx())
})

test_that("data is as documented", {
  t <- get_kierczak_et_al_2022_table_s3_xlsx()
  expect_true(tibble::is_tibble(t))
  expect_equal(608, nrow(t))
})
