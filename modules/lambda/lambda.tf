data "archive_file" "python_lambda_package" {  
  for_each      = var.lambda_name
  type = "zip"  
  source_file = "../../scripts/${each.key}.py" 
  output_path = "../../scripts/${each.key}.zip"
}

resource "aws_lambda_function" "python3" {
  for_each      = var.lambda_name
  function_name = "${var.env}_${each.key}"
  filename      = "../../scripts/${each.key}.zip"
  source_code_hash = data.archive_file.python_lambda_package[each.key].output_base64sha256
  role          = aws_iam_role.lambda_python3[each.key].arn
  runtime       = var.python_v
  handler       = "${each.key}.lambda_handler"
  timeout       = var.timeout
  
}