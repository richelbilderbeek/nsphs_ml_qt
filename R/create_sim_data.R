#' Create simulated quantitative GWAS data
create_sim_data <- function() {
  # First, use dataset from soybean, also a diploid organism:
  # https://cran.r-project.org/web/packages/SoyNAM/index.html
  library(SoyNAM)
  data(soybase)
  phenotype <- head(data.line.qa)
  genotype <- gen.qa[rownames(gen.qa) %in% qt$strain]
  list(
    phenotype = phenotype,
    genotype = genotype
  )
}
