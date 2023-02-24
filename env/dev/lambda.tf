// LAMBDAS - ONDEMAND //

module "lambdas-ondemand" {
  source = "../../modules/lambda"

  env = var.env
  lambda_name = var.lambda_od
  policy_name = var.lambda_od
  python_v = var.python_v
}

// LAMBDAS - SCHEDULED //

# module "lambdas-scheduled" {
#   source = "../../modules/lambda"

#   env = var.env
#   lambda_name = var.lambda_sc
#   policy_name = var.lambda_sc
#   cw_scheduler = true
#   python_v = var.python_v
# }

variable "lambda_od" {
  type = map
}

# variable "lambda_sc" {
#   type = map
# }