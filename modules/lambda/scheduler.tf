resource "aws_cloudwatch_event_rule" "scheduled_function" {
  # for_each = var.cw_scheduler == true ? toset([var.lambda_name]) : ([])
  for_each = {
    for k, v in var.lambda : k => v
    if var.cw_scheduler
    # for v in var.schedule : v => v...
  }
  name                  = "run-lambda-function-${each.value["name"]}"
  description           = "Schedule lambda function"
  schedule_expression   = each.value["schedule"]
}

resource "aws_cloudwatch_event_target" "scheduled_function" {
  for_each = {
    for k, v in var.lambda : k => v
    if var.cw_scheduler
  }
  target_id = "lambda-function-target"
  rule      = aws_cloudwatch_event_rule.scheduled_function[each.value.name].name
  arn       = aws_lambda_function.python3[each.value.name].arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  for_each = {
    for k, v in var.lambda : k => v
    if var.cw_scheduler
  }
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python3[each.value.name].function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.scheduled_function[each.value.name].arn
}