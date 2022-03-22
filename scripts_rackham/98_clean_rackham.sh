#!/bin/bash
#
# Clean up Rackham
#
# Usage:
#
#   ./98_clean_rackham.sh
#   ./nsphs_ml_qt/scripts_rackham/98_clean_rackham.sh
#
# Note that the first is a copy of the second, as copied by
# '00_create_starter_zip.sh'
#
SECONDS=0

rm -f nsphs_ml_qt_starter_zip.zip
rm -f *.log *.png
rm -rf GenoCAE  nsphs_ml_qt
rm -rf nsphs_ml_qt
rm -rf ~/.local/share/plinkr
rm -f 01_unzip_starter_zip.sh README.md 98_clean_rackham.sh

echo "Duration: $SECONDS seconds"

