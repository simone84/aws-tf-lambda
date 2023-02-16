terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {  
  }
}

variable "aws_region" {}
variable "python_v" {}
variable "env" {}

// LAMBDA NAME: instances_id //

module "lambda-instances_id" {
  source = "../../modules/lambda-ondemand"

  env = var.env
  lambda_name = "instances_id"
  python_v = var.python_v
}