resource "aws_cloudwatch_event_rule" "scheduled_function" {
  count = var.cw_scheduler ? 1 : 0
  name                  = "run-lambda-function"
  description           = "Schedule lambda function"
  schedule_expression   = var.schedule
}

resource "aws_cloudwatch_event_target" "scheduled_function" {
  count = var.cw_scheduler ? 1 : 0
  target_id = "lambda-function-target"
  rule      = element(aws_cloudwatch_event_rule.scheduled_function.*.name, 0)
  arn       = aws_lambda_function.python3.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count = var.cw_scheduler ? 1 : 0
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python3.function_name
  principal = "events.amazonaws.com"
  source_arn = element(aws_cloudwatch_event_rule.scheduled_function.*.arn, 0)
}