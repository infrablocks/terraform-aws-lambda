resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  description   = var.lambda_description

  filename         = var.lambda_zip_path
  handler          = var.lambda_handler
  source_code_hash = base64sha256(filebase64(var.lambda_zip_path))
  runtime          = local.lambda_runtime

  role = aws_iam_role.lambda_execution_role.arn

  timeout                        = local.lambda_timeout
  memory_size                    = local.lambda_memory_size
  reserved_concurrent_executions = local.lambda_reserved_concurrent_executions

  publish = local.publish

  tags = local.resolved_tags

  dynamic "environment" {
    for_each = var.lambda_environment_variables[*]
    content {
      variables = environment.value
    }
  }

  vpc_config {
    security_group_ids = local.deploy_in_vpc ? [aws_security_group.sg_lambda[0].id] : []
    subnet_ids         = local.deploy_in_vpc ? local.lambda_subnet_ids : []
  }
}
