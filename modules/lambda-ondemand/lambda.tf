data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "../../scripts/${var.lambda_name}.py" 
  output_path = "../../scripts/${var.lambda_name}.zip"
}

resource "aws_lambda_function" "python3" {
  function_name = "${var.env}_${var.lambda_name}"
  filename      = "../../scripts/${var.lambda_name}.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role          = aws_iam_role.lambda_python3.arn
  runtime       = var.python_v
  handler       = "${var.lambda_name}.lambda_handler"
  timeout       = var.timeout
}