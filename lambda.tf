// noinspection ConflictingProperties
resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_function_name
  description   = var.lambda_description

  package_type = var.lambda_package_type

  filename         = var.lambda_package_type == "Zip" ? var.lambda_zip_path : null
  handler          = var.lambda_package_type == "Zip" ? var.lambda_handler : null
  source_code_hash = var.lambda_package_type == "Zip" ? base64sha256(filebase64(var.lambda_zip_path)) : null
  runtime          = var.lambda_package_type == "Zip" ? var.lambda_runtime : null

  architectures = var.lambda_architectures

  image_uri = var.lambda_package_type == "Image" ? var.lambda_image_uri : null

  dynamic "image_config" {
    for_each = var.lambda_package_type == "Image" ? [var.lambda_image_config] : []

    content {
      command           = image_config.value.command
      working_directory = image_config.value.working_directory
      entry_point       = image_config.value.entry_point
    }
  }

  logging_config {
    log_format            = var.lambda_logging_config != null ? var.lambda_logging_config.log_format : "Text"
    log_group             = var.lambda_logging_config != null ? var.lambda_logging_config.log_group : var.include_lambda_log_group == true ? aws_cloudwatch_log_group.lambda["default"].name : null
    application_log_level = var.lambda_logging_config != null ? var.lambda_logging_config.application_log_level : null
    system_log_level      = var.lambda_logging_config != null ? var.lambda_logging_config.system_log_level: null
  }

  dynamic "tracing_config" {
    for_each = var.lambda_tracing_config != null ? [var.lambda_tracing_config] : []

    content {
      mode = tracing_config.value.mode
    }
  }

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
    security_group_ids = var.include_vpc_access ? [aws_security_group.lambda_security_group[0].id] : []
    subnet_ids         = var.include_vpc_access ? var.lambda_subnet_ids : []
  }
}
