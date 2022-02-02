# nsphs_ml_qt

> These are old notes.
>
> Use `scripts_bianca` and `scripts_rackham` instead

## File structure

 * `richel-sens2021565/gcaer.sif`: Singularity container with Python packages
 * `gcae_v1_0`: holds GenoCAE, as copied from `gcaer.sif`

To obtain this second folder, do:

```
singularity exec richel-sens2021565/gcaer.sif cp -r /opt/gcaer/gcae_v1_0/ .
```

 * `scripts`

Local, in `nsphs_ml_qt` folder:

```
zip nsphs_ml_qt_scripts.zip -r scripts
```

Move to Bianca, then:

```
unzip richel-sens2021565/nsphs_ml_qt_scripts.zip
```

## Constants due to file structure

```
datadir <- "/proj/sens2021565/nobackup/NSPHS_data/"
```

```
data <- "NSPHS.WGS.hg38.plink1"
```

The folder where `gcaer` (not GCAE!) is installed. 
It must have the GCAE subfolder called `gcae_v1_0`

```
gcae_options <- create_gcae_options(
  gcae_folder = "/home/richel/gcaer"
)
```

##

Do the full NSPHS ML QT experiment.

# `0_create_starter_zip.sh`

 * Goal: creates a zip file with all the files needed.
   This collection of files can then be copied to Rackham or Bianca.

Usage:

On a local computer or Rackham:

```
./0_create_starter_zip.sh
sbatch -A richelbilderbeek 0_create_starter_zip.sh
sbatch -A sens2021565 0_create_starter_zip.sh
```

Contains:

# `1_unzip.sh`

 * Goal: unzip the collection of files

Usage:

On a local computer, Rackham or Bianca:

```
./1_unzip.sh
sbatch -A richelbilderbeek 1_unzip.sh
sbatch -A sens2021565 1_unzip.sh
```


## 2

sbatch scripts/sbatch_rscript_to_gcaer_sif.sh scripts/2_do_short_experiment.R

