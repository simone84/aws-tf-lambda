#!/bin/bash

set -e

TFSTATE_KEY=$envx/terraform-lambda.state
wget https://releases.hashicorp.com/terraform/${tfversion}/terraform_${tfversion}_linux_amd64.zip --no-show-progress
unzip terraform_${tfversion}_linux_amd64.zip
echo "########## TF INIT ##########"  
./terraform init -backend-config="bucket=${bucket}"  -backend-config="key=${TFSTATE_KEY}" -backend-config="region=${region}"
echo "########## TF PLAN ##########"
set +e
./terraform plan -var-file=../../tfvars/$envx.tfvars -detailed-exitcode
CODE=$(echo $?)
echo "TF DETAILED EXIT CODE: $CODE"
set -e
if [ $CODE -eq 0 ]; then
    echo "### Applying is not required ###"
    ./terraform state list
elif [ $CODE -eq 1 ]; then
    echo "### There is an issue planning ###"
    exit 1
elif [ $CODE -eq 2 ]; then
    echo "########## TF APPLY ##########"
    ./terraform apply -var-file=../../tfvars/$envx.tfvars -auto-approve
    ./terraform state list
fi