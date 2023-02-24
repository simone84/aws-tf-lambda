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

if [[ $env == "dev" ]]; then
  cp -p templates/script.tpl scripts/${lambda_name}.py
  cp templates/policy.tpl policies/${lambda_name}.json
  ls -l scripts/${lambda_name}.py ; ls -l policies/${lambda_name}.json
fi

echo "Remember to update tfvars/${env}.tfvars file"
echo "  ${lambda_name}" = ${lambda_name}" "
echo "lambda_od map is for lambdas to run on demand"
echo "lambda_sc map is for scheduled by CW lambdas"
echo "The Key is the lambda name and the value is the policy name"
echo "If the policy name is split by environment ex:"
echo "${env}_${lambda_name} remember to change the value and the to rename the policy"