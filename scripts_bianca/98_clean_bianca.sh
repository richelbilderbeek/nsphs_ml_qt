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
SECONDS=0

rm -f richel-sens2021565/*.zip
rm -rf GenoCAE nsphs_ml_qt plink_1_9_unix plink_2_0_unix gcae gcaer
rm -f ./*.log ./*.png
rm -f 01_unzip_starter_zip.sh README.md 98_clean_bianca.sh

echo "Duration: $SECONDS seconds"

