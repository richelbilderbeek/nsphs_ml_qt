#!/bin/bash
#
# Zip the results for further analysis:
#
#  * The '.log' files
#    * Shorten '11_train_on_dataset.log' 
#  * the 'data_[x] folder' (where x is the data number)
#  * the 'data_[x]_ae folder' (where x is the data number)
#    * Without the 'weights' and 'pheno_weights' folder
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_bianca/17_zip_depersonalized_results.sh
#

zip_filename=nsphs_ml_qt_bianca_depersonalized_results.zip
echo "zip_filename: $zip_filename"

echo "Removing the weights"
rm -rf ~/data_1_ae/ae.M1.ex3.b_0_4.data_1.p1/weights
rm -rf ~/data_1_ae/ae.M1.ex3.b_0_4.data_1.p1/pheno_weights

echo "11_train_on_dataset.log is big, only use the start and end of it"
cp 11_train_on_dataset.log 11_train_on_dataset.bak
head 11_train_on_dataset.bak -n 70 > 11_train_on_dataset.log
tail 11_train_on_dataset.bak -n 10 >> 11_train_on_dataset.log
rm 11_train_on_dataset.bak

zip -r $zip_filename *.log $(ls | egrep "data") tidy_depersonalized_data

