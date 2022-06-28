test_that("IL-6RA", {
  protein_name <- "IL-6RA"
  t <- get_primary_signal(protein_name)
  expect_true(stringr::str_detect(t$X.Primary.Conditional.hit, "Primary"))
  expect_equal(t$Cis_Trans, "Cis")
})

test_that("IL-17RA", {
  protein_name <- "IL-17RA"
  t <- get_primary_signal(protein_name)
  expect_true(stringr::str_detect(t$X.Primary.Conditional.hit, "Primary"))
  expect_equal(t$Cis_Trans, "Cis")
})
