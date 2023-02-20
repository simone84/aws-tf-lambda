// LAMBDA NAME: instances_id //

module "lambda-instances_id" {
  source = "../../modules/lambda-ondemand"

  env = var.env
  lambda_name = "instances_id"
  python_v = var.python_v
}