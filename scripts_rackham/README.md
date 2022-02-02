# scripts_rackham

Scripts to be run on Rackham.

# Workflow

## 0. Zip

This is local, in the `nsphs_ml_qt` folder:

```
./scripts_rackham/00_create_starter_zip.sh
```

Creates a file called `nsphs_ml_qt_starter_zip.zip`

## 1. Unzip

First time:

```
unzip nsphs_ml_qt_starter_zip.zip
```

This will create a file called `01_unzip_starter_zip.sh` in the home folder,
so after that, one can do:

```
./01_unzip_starter_zip.sh
```

## 10. Create simulated dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
```

## 11. Train on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
```

## 12. [other steps on dataset 1]


## 98. Clean Rackham

```
./98_clean_rackham.sh
```

