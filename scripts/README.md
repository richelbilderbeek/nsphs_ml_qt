# nsphs_ml_qt

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


# `2_run`
To run:

./run.sh


