## New Python Lambda function ##

- Run the new_lambda script adding the lambda_name as parameter and the env
```
# Please use underscore for naming convention #
# You need to run the script first on dev, then on other envs
# if the first env is not dev you need to amend the script
# if you need a customised multi-env policy, please rename it and amend the mudule calling ex:
# "dev_ec2_pub_ips.json", and in the module block "policy_name = dev_ec2_pub_ips"

./new_lambda.sh ec2_pub_ips dev
```
- Edit your python script and the necessary policy
- Run terraform init/plan for testing
```
cd env/${env}
terraform init -backend-config="bucket=${bucket}" -backend-config="key=${environment}/terraform-lambda.state" -backend-config="region=${region}"
terraform plan -var-file=../../tfvars/${env}.tfvars
```
- PR, get it approved and merge on the main branch
- The Action will run automatically for dev modifies
```
Modifies on the following path will make the workflow run automatically:
* This will push developer to merge changes in dev ASAP

- 'env/dev/**'
- 'scripts/**'
- 'policies/**'
- 'modules/**'
```

- Apply the change running the action selecting the environemnt

### After the build: ###

Terraform will create 2 resources and 2 data for each lambda:
module.lambda-instances_id.data.archive_file.python_lambda_package
module.lambda-instances_id.data.aws_iam_policy_document.lambda_assume_role_policy
module.lambda-instances_id.aws_iam_role.lambda_ondemand
module.lambda-instances_id.aws_lambda_function.ondemand

The name of the role and the function will be:

```
lambdaRole_${env}_${lambda_name}

${env}_${lambda_name}
```

### EXTRA: ###
- The policy won't be available for additional resources being inline and built in the role

### CUSTOMISATION: ###
```
!!! Every modify in the module can affect all the functions in each environment !!!

!!! Every modify in the TFVAR can affect all the functions in the related environment !!!
```
- Module Calling (to customise a lambda only)

| Parameter   | Required | Default Value | Description                         |
| ----------- | -------- | ------------- | ----------------------------------- |
| env         | true     | null          | set only on the tfvars              |
| lambda_name | true     | null          | read naming convention rules        |
| policy_name | true     | null          | read policy convention rules        |
| python_v    | true     | null          | setup only if different from tfvars |
| timeout     | false    | 10            | lambda timeout                      |

- TFVARS (to customise an entire environment)

| Parameter  | Required | Default Value | Description                             |
| ---------- | -------- | ------------- | --------------------------------------- |
| env        | true     | null          | give the prefix on role and lambda name |
| aws_region | true     | null          | region where build resources            |
| python_v   | true     | null          | python version                          |

- GH Workflow (to setup/customise the shared workflow)

| Input       | Required | Default Value | Description                             |
| ----------- | -------- | ------------- | --------------------------------------- |
| environment | true     | dev           | pull and update the right tf state file |

* to update the TF Varsion amend the env var "tf_version"
* to update the env list amend the choise list
* if the default environment is not dev change it in the if condition (first command)

- GH Secrets

| Secret                | Required | Description          |
| --------------------- | -------- | -------------------- |
| aws_access_key_id     | true     | aws key_id           |
| aws_secret_access_key | true     | aws secret_key       |
| bucket                | true     | s3 bucket state file |
| region                | true     | s3 bucket region     |

## TBD, WIP, and DONE ##
- [X] Inline policy as json file 
- [X] Include the lambda role in the module
- [X] GH Action parameterised and split the state (by env) during the building
- [X] Building script to generate the tf code automatically
- [X] Split lambda and main tf files
- [X] Combined workflow
- [X] Multi-env policy module
- [X] Lambda-scheduled-by-CW Module
- [] Generic module and reimporting
- [] lambda_name for map

## How To edit the state file ##
* Not often is possible to recreate resources
* Even changing the resource name will trigger a rebuilding
```
# Run state list and take note of the resources to be changed #
terraform state list

# we will rename the following 2 resources from ondemand to a generic name python3
# module.lambda-list_buckets.aws_lambda_function.ondemand
# module.lambda-list_buckets.aws_iam_role.lambda_ondemand

terraform state mv module.lambda-list_buckets.aws_lambda_function.ondemand module.lambda-list_buckets.aws_lambda_function.python3
terraform state mv module.lambda-list_buckets.aws_iam_role.lambda_ondemand module.lambda-list_buckets.aws_iam_role.lambda_python3

# output should be like:
Move "module.lambda-instances_id.aws_iam_role.lambda_ondemand" to "module.lambda-instances_id.aws_iam_role.lambda_python3"
Successfully moved 1 object(s).

# if you plan now, no resources will be marked for changes. Well done!
```