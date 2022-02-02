#!/bin/bash
#
# Clean up Bianca
#
# Usage:
#
#   ./98_clean_bianca.sh
#   ./nsphs_ml_qt/scripts_bianca/98_clean_bianca.sh
#
# Note that the first is a copy of the second, as copied by
# '00_create_starter_zip.sh'
#

# Path at Bianca
rm -f richel-sens2021565/nsphs_ml_qt_starter_zip.zip

# Path at Rackham
rm -f nsphs_ml_qt_starter_zip.zip

rm -f *.log *.png
rm -rf GenoCAE  nsphs_ml_qt
rm -rf nsphs_ml_qt
rm -rf ~/.local/share/plinkr
rm -f 01_unzip_starter_zip.sh README.md 98_clean_bianca.sh

