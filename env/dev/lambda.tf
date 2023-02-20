// LAMBDA NAME: instances_id //

module "lambda-instances_id" {
  source = "../../modules/lambda-ondemand"

  env = var.env
  lambda_name = "instances_id"
  python_v = var.python_v
}

// LAMBDA NAME: list_buckets //

module "lambda-list_buckets" {
  source = "../../modules/lambda-ondemand"

  env = var.env
  lambda_name = "list_buckets"
  python_v = var.python_v
}