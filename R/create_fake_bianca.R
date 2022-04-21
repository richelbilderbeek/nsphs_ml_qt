#' Fake the environment on Bianca as realistic as possible,
#' so the 'scripts_bianca' scripts can be run locally
#' @export
create_fake_bianca <- function() {
  if (1 == 2) {
    bed_filename <- "/proj/sens2021565/nobackup/NSPHS_data/NSPHS.WGS.hg38.plink1.bed"
    nsphsr::create_bed_file(bed_filename = bed_filename)
    testthat::expect_true(file.exists(bed_filename))
  }

}
