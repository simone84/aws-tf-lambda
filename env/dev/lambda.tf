// LAMBDAS - ONDEMAND //

module "lambdas-ondemand" {
  source = "../../modules/lambda"

  env = var.env
  lambda = var.lambda_od
  python_v = var.python_v
}

variable "lambda_od" {
  type = map(object({
    name     = string
    policy   = string
    schedule = string
  }))
}

// LAMBDAS - SCHEDULED //

module "lambdas-scheduled" {
  source = "../../modules/lambda"

  env = var.env
  lambda = var.lambda_sc
  cw_scheduler = true
  python_v = var.python_v
}

variable "lambda_sc" {
  type = map(object({
    name     = string
    policy   = string
    schedule = string
  }))
}