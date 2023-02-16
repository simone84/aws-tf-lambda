## New Lambda function ##

- Run the new_lambda script adding the lambda_name as parameter
```
# Please use underscore for naming convention #
./new_lambda.sh ec2_pub_ips
```
- Edit your python script and the necessary policy
- Run terraform init/plan for testing
```
terraform init
terraform plan -var-file=../../tfvars/dev.tfvars
```
- PR, get it approved and merge on the main branch
- Apply the change running the action selecting the environemnt

### After the build: ###

Terraform will create 2 resources and 2 data for each lambda:
module.lambda-instances_id.data.archive_file.python_lambda_package
module.lambda-instances_id.data.aws_iam_policy_document.lambda_assume_role_policy
module.lambda-instances_id.aws_iam_role.lambda_ondemand
module.lambda-instances_id.aws_lambda_function.ondemand

The name of the role and the function will be:

lambdaRole_${env}_${lambda_name}

${env}_${lambda_name}

### EXTRA: ###
- The policy won't be available for additional resources being inline and built in the role

### TBD, WIP, and DONE ###
- [X] Inline policy as json file 
- [X] Include the lambda role in the module
- [X] GH Action parameterised and split the state (by env) during the building
- [X] Building script to generate the tf code automatically

### CUSTOMISATION: ###
