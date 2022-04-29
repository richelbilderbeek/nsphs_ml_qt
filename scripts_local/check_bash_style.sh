#!/bin/bash
#
# Check the bash scripts' style
# for all .sh scripts in the current folder and its subfolders
#
# Usage:
#
#   ./scripts_local/check_bash_style.sh
#
# 
#
#
shellcheck $(find . | grep "\\.sh$")
