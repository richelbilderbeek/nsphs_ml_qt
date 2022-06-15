#!/bin/bash
#
# Poll the number of jobs in the queue every minute for eternity
#
while true; 
do 
  date="$(date)"
  n_jobs_plus_one="$(squeue -u $USER | wc --lines)"
  n_jobs="$(${n_jobs_plus_one} - 1)"
  echo "${date}: ${n_jobs} jobs"
  sleep 60
done
