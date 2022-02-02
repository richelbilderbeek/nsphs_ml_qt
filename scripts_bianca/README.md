# scripts_bianca

Scripts to be run on Bianca.


# Workflow

## 0. Zip

This is local, in the `nsphs_ml_qt` folder:

```
./scripts_bianca/00_create_starter_zip.sh
```

## 1. Unzip

First time:

```
unzip richel-sens2021565/nsphs_ml_qt_starter_zip.zip
```

This will create a file called `01_unzip_starter_zip.sh` in the home folder,
so after that, one can do:

```
./01_unzip_starter_zip.sh
```

## 10. Create dataset 1

See [#4](https://github.com/richelbilderbeek/nsphs_ml_qt/issues/4):


```
sbatch nsphs_ml_qt/scripts_bianca/10_create_dataset_1.sh
```

## 11. Train on dataset 1

```
sbatch nsphs_ml_qt/scripts_bianca/11_train_on_dataset_1.sh
```

## 12. [other steps on dataset 1]

## 20. Create dataset 2

See [#5](https://github.com/richelbilderbeek/nsphs_ml_qt/issues/5)

```
sbatch nsphs_ml_qt/scripts_bianca/20_create_dataset_2.sh
```

## 21. Train on dataset 2

```
sbatch nsphs_ml_qt/scripts_bianca/21_train_on_dataset_2.sh
```

## 22. [other steps on dataset 2]

