data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "lambda_execution_assume_role_policy_document" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "vpc_access_management_statement" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSecurityGroups",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "log_management_statement" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    ]
  }
}

data "aws_iam_policy_document" "tracing_statement" {
  statement {
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_execution_role_policy_document" {
  source_policy_documents = compact(
    [
      var.include_vpc_access && var.include_execution_role_policy_vpc_access_management_statement
      ? data.aws_iam_policy_document.vpc_access_management_statement.json
      : "",
      var.include_execution_role_policy_log_management_statement
      ? data.aws_iam_policy_document.log_management_statement.json
      : "",
      var.lambda_tracing_config != null && var.include_execution_role_policy_tracing_statement
      ? data.aws_iam_policy_document.tracing_statement.json
      : "",
      var.lambda_execution_role_source_policy_document
    ]
  )
}

locals {
  default_assume_role_policy_document = data.aws_iam_policy_document.lambda_execution_assume_role_policy_document.json
  default_execution_role_policy_document = data.aws_iam_policy_document.lambda_execution_role_policy_document.json

  resolved_assume_role_policy_document = var.lambda_assume_role_policy_document != "" ? var.lambda_assume_role_policy_document : local.default_assume_role_policy_document
  resolved_execution_role_policy_document = var.lambda_execution_role_policy_document != "" ? var.lambda_execution_role_policy_document : local.default_execution_role_policy_document
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = local.resolved_assume_role_policy_document
  tags = local.resolved_tags
}

resource "aws_iam_role_policy" "lambda_execution_policy" {
  role = aws_iam_role.lambda_execution_role.id
  policy =  local.resolved_execution_role_policy_document
}

