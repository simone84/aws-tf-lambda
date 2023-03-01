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
- 'tfvars/dev/**'
```

- Apply the change running the action selecting the environemnt

### After the build: ###

Terraform will create 2 resources and 2 data for each lambda:

```
module.lambdas-ondemand.data.archive_file.python_lambda_package["instances_id"]
module.lambdas-ondemand.data.aws_iam_policy_document.lambda_assume_role_policy
module.lambdas-ondemand.aws_iam_role.lambda_python3["instances_id"]
module.lambdas-ondemand.aws_lambda_function.python3["instances_id"]
```
The name of the role and the function will be:
```
lambdaRole_${env}_${lambda_name}

${env}_${lambda_name}
```
if the scheduler is enabled also:
```
module.lambdas-ondemand.aws_cloudwatch_event_rule.scheduled_function["instances_id"]
module.lambdas-ondemand.aws_cloudwatch_event_target.scheduled_function["instances_id"]
module.lambdas-ondemand.aws_lambda_permission.allow_cloudwatch["instances_id"]
```

### EXTRA: ###
- The policy won't be available for additional resources being inline and built in the role

### CUSTOMISATION: ###
```
!!! Every modify in the module can affect all the functions in each environment !!!

!!! Every modify in the TFVAR can affect all the functions in the related environment !!!
```
- Module Calling (to customise the lambda with the same trigger only)

| Parameter | Type  | Required | Default Value | Description                         |
| --------- | ----- | -------- | ------------- | ----------------------------------- |
| env       | true  | true     | null          | set only on the tfvars              |
| lambda    | true  | true     | null          | setup on tfvars                     |
| python_v  | true  | true     | null          | setup only if different from tfvars |
| timeout   | false | false    | 10            | lambda timeout                      |
| scheduler | bool  | false    | true          | to enable CW scheduler              |

- TFVARS (to customise an entire environment)

| Parameter  | Type        | Required | Default Value | Description                             |
| ---------- | ----------- | -------- | ------------- | --------------------------------------- |
| env        | string      | true     | null          | give the prefix on role and lambda name |
| aws_region | string      | true     | null          | region where build resources            |
| python_v   | string      | true     | null          | python version                          |
| lambda_od  | map(object) | true     | null          | on demand lambda, follow req.           |
| lambda_sc  | map(object) | true     | null          | scheduled lmabda, follow req.           |

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
- [X] Generic module and reimporting
- [X] Lambda names and policy in a map
- [X] Schedule as parameter
- [X] Lambda as map of objects 

## How To edit the state file ##
* Not often is possible to recreate resources
* Even changing the resource name will trigger a rebuilding
```
# Run state list and take note of the resources to be changed #
terraform state list

# below we will rename the following 2 resources from ondemand to a generic name python3
# module.lambda-list_buckets.aws_lambda_function.ondemand
# module.lambda-list_buckets.aws_iam_role.lambda_ondemand

terraform state mv module.lambda-list_buckets.aws_lambda_function.ondemand module.lambda-list_buckets.aws_lambda_function.python3
terraform state mv module.lambda-list_buckets.aws_iam_role.lambda_ondemand module.lambda-list_buckets.aws_iam_role.lambda_python3

# output should be like:
Move "module.lambda-instances_id.aws_iam_role.lambda_ondemand" to "module.lambda-instances_id.aws_iam_role.lambda_python3"
Successfully moved 1 object(s).

# if you plan now, no resources will be marked for changes. Well done!

# below we will move the following 2 resources from 2 different modules incaplsuling resources in a map
# this is a perfect example when you move to for_each loops

terraform state mv module.lambda-list_buckets.aws_iam_role.lambda_python3 'module.lambdas-ondemand.aws_iam_role.lambda_python3["list_buckets"]'
terraform state mv module.lambda-list_buckets.aws_lambda_function.python3 'module.lambdas-ondemand.aws_lambda_function.python3["list_buckets"]'

# if you plan now, no resources will be marked for changes. Well done!
# run a dry terrafrom apply to let terraform to reindex the data resources in a different module
```

## Move from Counter to for_each (map) ##

* Check out PR:
https://github.com/simone84/aws-tf-lambda/pull/5

```
# the counter ex:
count = var.cw_scheduler ? 1 : 0
# and the interpolation:
rule = element(aws_cloudwatch_event_rule.scheduled_function.*.name, 0)
source_arn = element(aws_cloudwatch_event_rule.scheduled_function.*.arn, 0)

# is getting obsolete and we move on for_each with more flexibility

for_each = var.cw_scheduler == true ? toset([var.lambda_name]) : ([])
# works to enable the resource creation with a provided array

# in this case we need to call for inside for_each (nesting for) because we have a map of key/values
# we can add an if condition to enable the loop when the bool var is true
  for_each = {
    for k, v in var.lambda : k => v
    if var.cw_scheduler
  }

name = "run-lambda-function-${each.key}"
rule = aws_cloudwatch_event_rule.scheduled_function[each.key].name
# etc.
```

## Move from for_each map to map(objects) ##
* Check PR:
https://github.com/simone84/aws-tf-lambda/pull/6

```
# This is mainly to accomodate 3+ values for each resource because key/value strategy is not enough
# move the lambda var map to:
variable "lambda" {
  type = map(object({
    name     = string
    policy   = string
    schedule = string
  }))
}

# the interaction will be similar pointing in this case on values only specifying which object ["xxx"]
name = "run-lambda-function-${each.value["name"]}"
schedule_expression = each.value["schedule"]
arn = aws_lambda_function.python3[each.value.name].arn
```