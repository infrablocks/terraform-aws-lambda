output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}
output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}
output "lambda_qualified_arn" {
  value = aws_lambda_function.lambda.qualified_arn
}
output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}
output "lambda_handler" {
  value = aws_lambda_function.lambda.handler
}
output "lambda_last_modified" {
  value = aws_lambda_function.lambda.last_modified
}
output "lambda_id" {
  value = aws_lambda_function.lambda.id
}
output "lambda_memory_size" {
  value = aws_lambda_function.lambda.memory_size
}
output "lambda_runtime" {
  value = aws_lambda_function.lambda.runtime
}
output "lambda_source_code_hash" {
  value = aws_lambda_function.lambda.source_code_hash
}
output "lambda_source_code_size" {
  value = aws_lambda_function.lambda.source_code_size
}
output "lambda_image_uri" {
  value = aws_lambda_function.lambda.image_uri
}
output "lambda_version" {
  value = aws_lambda_function.lambda.version
}
output "lambda_log_group_name" {
  value = var.include_lambda_log_group ? aws_cloudwatch_log_group.lambda["default"].name : null
}
output "security_group_id" {
  value = var.include_vpc_access ? aws_security_group.lambda_security_group[0].id : null
}
output "security_group_name" {
  value = var.include_vpc_access ? aws_security_group.lambda_security_group[0].name : null
}
output "iam_role_name" {
  value = aws_iam_role.lambda_execution_role.name
}
output "iam_role_policy_name" {
  value =  aws_iam_role_policy.lambda_execution_policy.name
}
