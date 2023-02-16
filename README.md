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
- The Action will run automatically for dev modifies
```
Modifies on the following path will make the workflow run automatically:

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
```
!!! Every modify in the module or TFVAR can affect all the functions in each environment !!!
```
- Module Calling (to customise a lambda only)

| Parameter   | Required | Default Value | Description                         |
| ----------- | -------- | ------------- | ----------------------------------- |
| env         | true     | null          | set only on the tfvars              |
| lambda_name | true     | null          | read naming convention rules        |
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

- GH Secrets

| Secret                | Required | Description          |
| --------------------- | -------- | -------------------- |
| aws_access_key_id     | true     | aws key_id           |
| aws_secret_access_key | true     | aws secret_key       |
| bucket                | true     | s3 bucket state file |
| region                | true     | s3 bucket region     |