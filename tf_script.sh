#!/bin/bash

set -e

TFSTATE_BUCKET=$bucket # infra984
TFSTATE_KEY=$envx/terraform.tfstate
TFSTATE_REGION=TFSTATE_REGION eu-west-2
wget https://releases.hashicorp.com/terraform/${tfversion}/terraform_${tfversion}_linux_amd64.zip
unzip terraform_${tfversion}_linux_amd64.zip
echo "########## TF INIT ##########"  
./terraform init -backend-config="bucket=${TFSTATE_BUCKET}"  -backend-config="key=${TFSTATE_KEY}" -backend-config="region=${TFSTATE_REGION}"
echo "########## TF PLAN ##########"
set +e
./terraform plan -var-file=tfvars/$envx.tfvars -detailed-exitcode
CODE=$(echo $?)
echo "TF DETAILED EXIT CODE: $CODE"
set -e
if [ $CODE -eq 0 ]; then
    echo "### Applying is not required ###"
    ./terraform state list
elif [ $CODE -eq 1 ]; then
    echo "### There is an issue planning ###"
elif [ $CODE -eq 2 ]; then
    echo "########## TF APPLY ##########"
    ./terraform apply -var-file=tfvars/$envx.tfvars -auto-approve
    ./terraform state list
fi