// LAMBDA NAME: XXX_LAMBDA_NAME_XXX //

module "lambda-XXX_LAMBDA_NAME_XXX" {
  source = "../../modules/lambda-ondemand"

  env = var.env
  lambda_name = "XXX_LAMBDA_NAME_XXX"
  policy_name = "XXX_LAMBDA_NAME_XXX"
  python_v = var.python_v
}