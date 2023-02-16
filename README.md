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
terraform plan -var-file=tfvars/dev.tfvars
```
- Apply the change running the action

### TBD and WIP ###
- [X] Inline policy as module variable 
- [X] Include the lambda role in the module
- [] GH Action parameterised and split the state (by env) during the building
- [X] Building script to generate the tf code automatically