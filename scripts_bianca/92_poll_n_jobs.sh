#!/bin/bash
#
# Poll the number of jobs in the queue every minute for eternity
#
while true; do echo "$(date): $($(squeue -u "$USER" | wc --lines) - 1) jobs" ; sleep 60; done
