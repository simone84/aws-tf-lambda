// LAMBDA ONDEMAND //


module "lambdas-ondemand" {
  source = "../../modules/lambda"

  env = var.env
  lambda_name = var.lambda_name
  policy_name = var.lambda_name
  # cw_scheduler = true
  python_v = var.python_v
}

variable "lambda_name" {
  type = map
}