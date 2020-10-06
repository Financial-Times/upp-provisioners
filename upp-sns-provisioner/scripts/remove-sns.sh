set -euo pipefail
IFS=$'\n\t'

 if [ "$#" -ne  "1" ]
   then
     echo "One arguments is missing"
     echo "remove-sns.sh <CLOUDFORMATION_STACK_NAME>"
     exit 1
 fi

STACK_NAME=$1

aws cloudformation  delete-stack \
  --stack-name "${STACK_NAME}"
