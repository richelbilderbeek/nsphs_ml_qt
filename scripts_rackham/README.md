# scripts_rackham

Scripts to be run on Rackham.

# Workflow

## 0. Zip

This is local, in the `nsphs_ml_qt` folder:

```
./scripts_rackham/00_create_starter_zip.sh
```

Creates a file called `nsphs_ml_qt_starter_zip.zip`

## 20 start

These are run scripts that can be run with/out `sbatch`, as
these `sbatch` all that needs to be `sbatch`ed

## 21 create

Create an experiment file and a dataset

## 25 run

Run an experiment file

## 28 analyse

Analyse the results of an experiment file

## 29 zip

Analyse the results of an experiment file




## Old workflow

The old workflow, with numbers from 2 to and including 19
directly calls GCAE `train`, then `project`, then `evaluate`,
without generating intermediate results.

Prefer using the new workflow.

## 2. Start simulated dataset 1


```
./nsphs_ml_qt/scripts_rackham/02_start_1.sh
```

## 10. Create simulated dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
```

## 11. Train on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/11_train_on_dataset_1.sh
```

## 12. Project on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/12_project_on_dataset_1.sh
```

## 13. Plot on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/13_plot_on_dataset_1.sh
```

## 14. Animate on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/14_animate_on_dataset_1.sh
```

## 15. Evaluate on dataset 1

```
sbatch nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset_1.sh
```

## 98. Clean Rackham

```
./98_clean_rackham.sh
```

