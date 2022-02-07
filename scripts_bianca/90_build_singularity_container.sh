#!/bin/bash
#
# Build the Singularity container called `nsphs_ml_qt.sif`
# from the Singularity recipe `Singularity` (which is a default
# name for a Singularity recipe)
#
# Usage:
#
# ./scripts/90_build_singularity_container.sh
#
#
sudo -E singularity --quiet build nsphs_ml_qt.sif Singularity

if [[ $HOSTNAME == "N141CU" ]]; then
  notify-send "Done creating 'nsphs_ml_qt.sif'" "Done creating 'nsphs_ml_qt.sif'"
fi

