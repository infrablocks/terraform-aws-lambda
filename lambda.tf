resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  description   = var.lambda_description

  package_type = var.lambda_package_type

  filename         = var.lambda_zip_path
  handler          = var.lambda_handler
  source_code_hash = base64sha256(filebase64(var.lambda_zip_path))
  runtime          = var.lambda_runtime

  role = aws_iam_role.lambda_execution_role.arn

  timeout                        = var.lambda_timeout
  memory_size                    = var.lambda_memory_size
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  publish = var.publish

  tags = local.resolved_tags

  dynamic "environment" {
    for_each = var.lambda_environment_variables[*]
    content {
      variables = environment.value
    }
  }

  vpc_config {
    security_group_ids = var.include_vpc_access ? [aws_security_group.sg_lambda[0].id] : []
    subnet_ids         = var.include_vpc_access ? var.lambda_subnet_ids : []
  }
}
