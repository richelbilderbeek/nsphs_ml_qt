#!/bin/bash
#
# Do a full flow for Issue 6.
#
# Usage: 
#
#   ./nsphs_ml_qt/scripts_rackham/02_start_1.sh
#
# No sbatch: this script is intended to run locally
#
SECONDS=0
echo "Starting time: $(date --iso-8601=seconds)"
echo "Running on computer with HOSTNAME: $HOSTNAME"
echo "Running at location $(pwd)"

unique_id=issue_6
datadir=~/sim_data_${unique_id}/ # Really need that slash
data="sim_data_${unique_id}"
trainedmodeldir=~/sim_data_${unique_id}_ae/ # Really need that slash
base_input_filename="${datadir}${data}"
superpops="${base_input_filename}_labels.csv"

n_individuals=100
n_random_snps=0

epochs=100
epoch=$epochs
save_interval=10
pheno_model_id="p1"
metrics="hull_error,f1_score_3,f1_score_5,f1_score_7,f1_score_9,f1_score_11,f1_score_13,f1_score_15,f1_score_17,f1_score_19"

echo "datadir: ${datadir}"
echo "data: ${data}"
echo "base_input_filename: ${base_input_filename}"
echo "trainedmodeldir: $trainedmodeldir"
echo "superpops: ${superpops}"
echo "n_individuals: ${n_individuals}"
echo "n_random_snps: ${n_random_snps}"
echo "datadir: $datadir"
echo "epochs: $epochs"
echo "epoch: $epoch"
echo "save_interval: ${save_interval}"
echo "pheno_model_id: ${pheno_model_id}"
echo "metrics: ${metrics}"

if [ ! -f gcae/gcae.sif ]; then
  echo "'gcae/gcae.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'gcae' folder:"
  cd gcae ; ls ; cd -
  exit 42
fi
if [ ! -f nsphs_ml_qt/nsphs_ml_qt.sif ]; then
  echo "'nsphs_ml_qt.sif' file not found"
  echo "Showing pwd:"
  ls
  echo "Showing content of the 'gcaer' folder:"
  cd gcaer ; ls ; cd -
  exit 42
fi

./nsphs_ml_qt/scripts_rackham/10_create_dataset_2.sh    $base_input_filename $n_individuals $n_random_snps                        
./nsphs_ml_qt/scripts_rackham/11_train_on_dataset.sh    $datadir $data $trainedmodeldir $epochs $save_interval $pheno_model_id    
./nsphs_ml_qt/scripts_rackham/12_project_on_dataset.sh  $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id         
./nsphs_ml_qt/scripts_rackham/13_plot_on_dataset.sh     $datadir $data $trainedmodeldir $superpops $epoch $pheno_model_id         
./nsphs_ml_qt/scripts_rackham/14_animate_on_dataset.sh                                                                            
./nsphs_ml_qt/scripts_rackham/15_evaluate_on_dataset.sh $datadir $data $trainedmodeldir $superpops $metrics $save_interval $epochs $pheno_model_id
./nsphs_ml_qt/scripts_rackham/16_create_tidy_results.sh $datadir $trainedmodeldir $unique_id                                      
./nsphs_ml_qt/scripts_rackham/17_zip_results.sh         $datadir $trainedmodeldir $unique_id                                      

echo "End time: $(date --iso-8601=seconds)"
echo "Duration: $SECONDS seconds"

