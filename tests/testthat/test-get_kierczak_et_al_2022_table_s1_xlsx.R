test_that("minimal use", {
  expect_silent(get_kierczak_et_al_2022_table_s1_xlsx())
})

test_that("data is as documented", {
  t <- get_kierczak_et_al_2022_table_s1_xlsx()
  expect_true(tibble::is_tibble(t))

  # Quote from text: 'In this study, we have analysed SNVs and indels,
  # identified by deep coverage WGS, in relation to the protein expression
  # levels of 414 plasma proteins'
  expect_equal(414, nrow(t))

  t2 <- t[t$Protein == "IL-12B", ]
  t[duplicated(t$Protein),]
  length(unique(t$Protein))
  length(t$Protein)
  sum(t$Protein %in% t$Protein)
})
