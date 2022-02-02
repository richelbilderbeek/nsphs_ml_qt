# scripts_bianca

Scripts to be run on Bianca.

# Workflow

## 0. Zip

This is local, in the `nsphs_ml_qt` folder:

```
./scripts_bianca/0_create_starter_zip.sh
```

## 1. Unzip

First time:

```
unzip [sens-something-folder]/*.zip
```

This will create a file called `unzip.sh` in the home folder,
so after that, one can do:

```
./1_unzip_starter_zip.sh
```

## 10. Create dataset 1

See [#4](https://github.com/richelbilderbeek/nsphs_ml_qt/issues/4):


```
./10_create_dataset_1.sh
```

## 11. Train on dataset 1

```
./11_train_on_dataset_1.sh
```

## 12. [other steps on dataset 1]

## 20. Create dataset 2

See [#5](https://github.com/richelbilderbeek/nsphs_ml_qt/issues/5)

```
./20_create_dataset_2.sh
```

## 21. Train on dataset 2

```
./21_train_on_dataset_2.sh
```

## 22. [other steps on dataset 2]

