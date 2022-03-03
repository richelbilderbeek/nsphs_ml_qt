#!/bin/bash
#
# Zip the results:
#  * The '.log' files
#  * the 'sim_data_[x] folder' (where x is the simulated data number)
#  * the 'sim_data_[x]_ae folder' (where x is the simulated data number)
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/16_zip_results.sh
#

zip_filename=nsphs_ml_qt_rackham_results.zip
echo "zip_filename: $zip_filename"

zip -r $zip_filename *.log $(ls | egrep "sim_data")

