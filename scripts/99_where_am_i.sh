#!/bin/bash
#
# Show where this script is run
#
# Usage:
#
#   ./99_where_am_i.sh
#   ./scripts/99_where_am_i.sh
#
echo "HOSTNAME: $HOSTNAME"
if [[ $HOSTNAME == "N141CU" ]]; then
  echo "On Richel's computer"
else 
  echo "At unknown location"
fi
