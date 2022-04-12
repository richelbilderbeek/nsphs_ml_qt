test_that("use", {
  expect_silent(get_kierczak_et_al_2022_table_s2_xlsx())
  expect_silent(get_kierczak_et_al_2022_table_s2_xlsx())
})

test_that("data matches manuscript", {
  t <- get_kierczak_et_al_2022_table_s2_xlsx()
  expect_true(tibble::is_tibble(t))
  expect_equal(478, nrow(t))

  # From the text
  # However, to include as many lead GWAS SNVs and indels as possible in the
  # conditional SKAT analyses, we first used a liberal significance
  # threshold of 5x10−8 in the GWAS.
  alpha <- 5e-8
  expect_true(all(t$P.value < alpha))
  # A total of 274 proteins had at least one significant SNV or indel
  # (217 proteins had any Cis and 107 any Trans) association
  # (Supplementary Table S2).
  expect_equal(274, length(unique(t$Protein)))
  cis_associations <- dplyr::filter(t, Cis_Trans == "Cis")
  expect_equal(217, length(unique(cis_associations$Protein)))
  trans_associations <- dplyr::filter(t, Cis_Trans == "Trans")
  expect_equal(107, length(unique(trans_associations$Protein)))
})

test_that("count number of unique protein-gene associations", {
  # Most associations are between a protein and multiple spots
  # on the same gene
  # How many polygenic associations are there?
  t <- get_kierczak_et_al_2022_table_s2_xlsx()
  t_distinct <- dplyr::distinct(dplyr::select(t, Protein, Gene))
  testthat::expect_equal(275, nrow(t_distinct))

  # It appears most proteins simply map to their gene.
  # How similar (in Levenshtein distance, see adist doc)
  # are the proteins to the genes?
  #
  # First remove all the dashes from the names, and more everything uppercase
  t_distinct_simplified <- t_distinct
  t_distinct_simplified$Protein <- stringr::str_replace_all( # nolint variable naming convention used in spreadsheet
    t_distinct_simplified$Protein, "-", ""
  )
  t_distinct_simplified$Gene <- stringr::str_replace_all( # nolint variable naming convention used in spreadsheet
    t_distinct_simplified$Gene, "-", ""
  )
  t_distinct_simplified$Protein <- stringr::str_to_upper( # nolint variable naming convention used in spreadsheet
    t_distinct_simplified$Protein
  )
  t_distinct_simplified$Gene <- stringr::str_to_upper( # nolint variable naming convention used in spreadsheet
    t_distinct_simplified$Gene
  )
  # 204 proteins map to their exact gene
  expect_equal(
    204,
    sum(t_distinct_simplified$Protein == t_distinct_simplified$Gene)
  )
  # Look at the 71 interesting associations
  # between a protein and a gene with a different name.
  # Note that these associations are not always interesting,
  # e.g. the protein 'PROTEINBOC' is associated with the 'BOC' gene
  t_distinct_interesting <- t_distinct_simplified[
    t_distinct_simplified$Protein != t_distinct_simplified$Gene,
  ]
  expect_equal(
    71,
    nrow(t_distinct_interesting)
  )


  distances <- rep(NA, nrow(t_distinct_simplified))
  for (i in seq_len(nrow(t_distinct_simplified))) {
    distances[i] <- adist(
      t_distinct_simplified$Protein[i],
      t_distinct_simplified$Gene[i]
    )
  }
  hist(distances, breaks = max(distances))
  expect_equal(204, sum(distances == 0))
})

test_that("find a SNP with a Cis association with a low p value", {
  return() # For Issue #5, https://github.com/richelbilderbeek/nsphs_ml_qt/issues/5
  t <- get_kierczak_et_al_2022_table_s2_xlsx()
  t_sorted_on_p_value <- t[order(t$P.value), ]
  names(t_sorted_on_p_value)

  best_hit <- t_sorted_on_p_value[1, ]
  knitr::kable(t(best_hit))

  ggplot2::ggplot(
    t_sorted_on_p_value[1:10, ],
    ggplot2::aes(x = seq(1:10), y = P.value)
  ) + ggplot2::geom_point()

  plot([1:100, ])
})
