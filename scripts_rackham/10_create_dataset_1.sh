#!/bin/bash
#
# Create simulated dataset 1
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
#   sbatch ./nsphs_ml_qt/scripts_rackham/10_create_dataset_1.sh
#
#
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

Rscript nsphs_ml_qt/scripts_rackham/10_create_dataset_1.R


