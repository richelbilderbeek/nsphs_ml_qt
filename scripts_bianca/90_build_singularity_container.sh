#!/bin/bash
#
# Build the Singularity container called `nsphs_ml_qt.sif`
# from the Singularity recipe `Singularity` (which is a default
# name for a Singularity recipe)
#
# Usage:
#
# ./scripts_bianca/90_build_singularity_container.sh
#
#

if [[ $HOSTNAME != "N141CU" ]]; then
  echo "Error: this script must run locally"
  echo "HOSTNAME: $HOSTNAME"
  exit 42
fi

if [[ $(pwd) != "/home/richel/GitHubs/nsphs_ml_qt" ]]; then
  echo "Error: this script must run from '/home/richel/GitHubs/nsphs_ml_qt'"
  echo "pwd: $(pwd)"
  echo ""
  echo "Tip: run this script by using:"
  echo ""
  echo "  ./scripts_bianca/90_build_singularity_container.sh"
  exit 42
fi


sudo -E singularity --quiet build nsphs_ml_qt.sif scripts_bianca/Singularity

if [[ $HOSTNAME == "N141CU" ]]; then
  notify-send "Done creating 'nsphs_ml_qt.sif'" "Start testing ..."
fi

singularity run nsphs_ml_qt.sif ../GenoCAE/run_gcae.py --help

if [[ $HOSTNAME == "N141CU" ]]; then
  notify-send "Done testing 'nsphs_ml_qt.sif'" "Done"
fi

