#!/bin/bash
#
# Poll the queue every minute for eternity
#
while true; do squeue -u "$USER"; sleep 60; done
