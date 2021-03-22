resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  description = var.lambda_description

  filename = var.lambda_zip_path
  handler = var.lambda_handler
  source_code_hash = base64sha256(filebase64(var.lambda_zip_path))
  runtime = var.lambda_runtime

  role = aws_iam_role.lambda_execution_role.arn

  timeout = var.lambda_timeout
  memory_size = var.lambda_memory_size

  publish = var.publish == "yes" ? true : false

  tags = local.tags

  environment {
    variables = var.lambda_environment_variables
  }

  vpc_config {
    security_group_ids = var.deploy_in_vpc == "yes" ? [
      aws_security_group.sg_lambda[0].id
    ] : []
    subnet_ids = var.deploy_in_vpc == "yes" ? var.lambda_subnet_ids : []
  }
}
