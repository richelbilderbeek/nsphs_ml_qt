# See if 'finishedjobinfo' exists
#
# It does not do so on a regular local computer
#
# Usage:
#
#   ./test_finishedjobs.sh
#
if command -v finishedjobinfo &> /dev/null
then
  echo "Yes, finishedjobinfo exists"
else
  echo "Nope, finishedjobinfo does not exist"
fi

