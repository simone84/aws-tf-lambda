#!/bin/bash

if [ -n "$1" ]; then
  lambda_name="$1"
  echo "$lambda_name code has been initialised"
else
  echo "Please add the name of the lambda ao parameter EX:"
  echo "./new_lambda.sh shutdown_vms"
  exit 1
fi

cp -p templates/script.tpl scripts/${lambda_name}.py
cp templates/policy.tpl policies/${lambda_name}.json
echo "" >> main.tf; echo "" >> main.tf
sed "s/XXX_LAMBDA_NAME_XXX/$lambda_name/g" templates/lambda_ondemand.tpl >> main.tf
ls -l scripts/${lambda_name}.py ; ls -l policies/${lambda_name}.json