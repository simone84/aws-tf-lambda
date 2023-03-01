data "archive_file" "python_lambda_package" {  
  for_each      = var.lambda
  type = "zip"  
  source_file = "../../scripts/${each.value["name"]}.py" 
  output_path = "../../scripts/${each.value["name"]}.zip"
}

resource "aws_lambda_function" "python3" {
  for_each      = var.lambda
  function_name = "${var.env}_${each.value["name"]}"
  filename      = "../../scripts/${each.value["name"]}.zip"
  source_code_hash = data.archive_file.python_lambda_package[each.value.name].output_base64sha256
  role          = aws_iam_role.lambda_python3[each.value.name].arn
  runtime       = var.python_v
  handler       = "${each.value["name"]}.lambda_handler"
  timeout       = var.timeout
  
}