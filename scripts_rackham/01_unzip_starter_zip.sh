#!/bin/bash
#
# Unzip the starter zip
#
# Usage: 
#
#   ./01_unzip_starter_zip.sh
#   ./nsphs_ml_qt/scripts_rackham/01_unzip_starter_zip.sh
#
# Note that the first is a copy of the second, as copied by
# '00_create_starter_zip.sh'
#

SECONDS=0

zip_filename=nsphs_ml_qt_rackham_starter_zip.zip
echo "zip_filename: $zip_filename"

unzip -y $zip_filename

echo "Duration: $SECONDS seconds"

