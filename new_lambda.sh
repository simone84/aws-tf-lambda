#!/bin/bash

if [ -n "$1" ] && [ -n "$2" ]; then
  lambda_name="$1"
  env="$2"
  echo "$lambda_name code has been initialised for $env environment"
else
  echo "Please add the name of the lambda as parameter + the env EX:"
  echo "./new_lambda.sh shutdown_vms dev"
  echo "!Remember to apply on dev first!"
  exit 1
fi

echo "" >> env/${env}/lambda.tf; echo "" >> env/${env}/lambda.tf
sed "s/XXX_LAMBDA_NAME_XXX/$lambda_name/g" templates/lambda_ondemand.tpl >> env/${env}/lambda.tf

if [[ $env == "dev" ]]; then
  cp -p templates/script.tpl scripts/${lambda_name}.py
  cp templates/policy.tpl policies/${lambda_name}.json
  ls -l scripts/${lambda_name}.py ; ls -l policies/${lambda_name}.json
fi

echo "env/${env}/lambda.tf file updated"