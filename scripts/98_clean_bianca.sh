#!/bin/bash
#
# Clean up Bianca
#
# Usage:
#
#   ./nsphs_ml_qt/scripts/98_clean_bianca.sh
#

# Path at Bianca
rm -f richel-sens2021565/0_starter_zip.zip

# Path at Rackham
rm -f 0_starter_zip.zip

rm -f README.md *.log *.png *.sh
rm -rf gcaer  GenoCAE  nsphs_ml_qt

