data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "../../scripts/${var.lambda_name}.py" 
  output_path = "../../scripts/${var.lambda_name}.zip"
}

resource "aws_lambda_function" "ondemand" {
        function_name = "${var.env}_${var.lambda_name}"
        filename      = "../../scripts/${var.lambda_name}.zip"
        source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
        role          = aws_iam_role.lambda_ondemand.arn
        runtime       = var.python_v
        handler       = "${var.lambda_name}.lambda_handler"
        timeout       = var.timeout
}

variable "env" {}
variable "lambda_name" {}
variable "python_v" {}
variable "timeout" {
  default = 10
}

# resource "aws_cloudwatch_event_rule" "scheduled_function" {
#   name                  = "run-lambda-function"
#   description           = "Schedule lambda function"
#   schedule_expression   = "rate(3 minutes)"
# }

# resource "aws_cloudwatch_event_target" "scheduled_function" {
#   target_id = "lambda-function-target"
#   rule      = aws_cloudwatch_event_rule.scheduled_function.name
#   arn       = aws_lambda_function.scheduled_function.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#     statement_id = "AllowExecutionFromCloudWatch"
#     action = "lambda:InvokeFunction"
#     function_name = aws_lambda_function.scheduled_function.function_name
#     principal = "events.amazonaws.com"
#     source_arn = aws_cloudwatch_event_rule.scheduled_function.arn
# }