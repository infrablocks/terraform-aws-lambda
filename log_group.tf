resource "aws_cloudwatch_log_group" "lambda" {
  for_each = var.include_lambda_log_group ? toset(["default"]) : toset([])
  name = "/${var.component}/${var.deployment_identifier}/lambda/${var.lambda_name}"
}
