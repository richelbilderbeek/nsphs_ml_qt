basename <- "~/GitHubs/nsphs_ml_qt/issues/richel_issue_126/home/richel/sim_data_2_richel_issue_126/sim_data_2_richel_issue_126"
bed_filename <- paste0(basename, ".bed")
bim_filename <- paste0(basename, ".bim")
fam_filename <- paste0(basename, ".fam")
phe_filename <- paste0(basename, ".phe")

phe_table <- plinkr::read_plink_phe_file(phe_filename = phe_filename)
knitr::kable(plinkr::read_plink_bed_file_from_files(bed_filename = bed_filename, bim_filename = bim_filename, fam_filename = fam_filename)[ , 1:5])
knitr::kable(plinkr::read_plink_bim_file(bim_filename = bim_filename))
knitr::kable(head(plinkr::read_plink_fam_file(fam_filename = fam_filename), n = 5))
knitr::kable(head(phe_table, n = 5))

assoc_qt_result <- plinkr::assoc_qt(
  assoc_qt_data = plinkr::create_assoc_qt_data(
    data = plinkr::create_plink_bin_filenames(
      bed_filename = bed_filename,
      bim_filename = bim_filename,
      fam_filename = fam_filename
    ),
    phenotype_data = plinkr::create_phenotype_data_table(phe_table = phe_table)
  )
)
qassoc_filename <- assoc_qt_result$qassoc_filenames
qassoc_table <- plinkr::read_plink_qassoc_file(qassoc_filename = qassoc_filename)
knitr::kable(qassoc_table)
