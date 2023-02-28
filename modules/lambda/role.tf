data "aws_iam_policy_document" "lambda_assume_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_python3" {
  for_each           = var.lambda  
  name               = "lambdaRole_${var.env}_${each.value["name"]}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name = "my_inline_policy"
    policy = file("../../policies/${each.value["policy"]}.json")

  }
  
}