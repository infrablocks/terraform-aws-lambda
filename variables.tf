# Component / Service & AWS Account Settings
variable "region" {
  description = "AWS region"
}

variable "account_id" {
  description = "AWS account id where the lambda execution"
}

variable "component" {
  description = "The name of the component or service"
}

variable "deployment_identifier" {
  description = "The deployment identifier to use e.g. <deployment_type>-<deployment_label>"
}

variable "deployment_label" {
  description = "The deployment label to use"
}

variable "deployment_type" {
  description = "The deployment type to use"
}

# Lambda Settings

variable "lambda_function_name" {
  description = "The name to use for the lambda function"
}

variable "lambda_description" {
  description = "The description to use for the AWS Lambda"
  default = ""
}

variable "lambda_handler" {
  description = "The name of the handler to use for the lambda function"
}

variable "lambda_zip_path" {
  description = "The location where the generated zip file should be stored"
}

variable "lambda_runtime" {
  description = "The runtime to use for the lambda function"
  default = "nodejs10.x"
}

variable "lambda_timeout" {
  description = "The timeout period to use for the lambda function"
  default = 30
}

variable "lambda_memory_size" {
  description = "The amount of memeory to use for the lambda function"
  default = 128
}

variable "lambda_execution_policy" {
  description = "The inline AWS execution policy to use for the lambda"
  default =  ""
}

variable "lambda_assume_role" {
  description = "An inline AWS role policy which the lambda should assume during execution"
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

variable "lambda_environment_variables" {
  description = "Environment variables to be provied to the lambda function."
  type = map(string)
}

locals {
  tags = var.tags != null ? var.tags  : {
    "Component" = var.component,
    "DeploymentType" = var.deployment_type,
    "DeploymentLabel" = var.deployment_label,
    "DeploymentIdentifier" = var.deployment_identifier
  }
}

variable "tags" {
  description = "AWS tags to use on created infrastructure components"
  default = null
}

# Deployment Options

variable "deploy_in_vpc" {
  description = "Set to true to deploy the lambda in a vpc environment"
  type = bool
  default = true
}

# VPC Deployment Settings

variable "vpc_id" {
  description = "VPC to deploy the lambda to"
}

variable "lambda_subnet_ids" {
  description = "Subnet ids to deploy the lambda to"
  type = list(string)
}

variable "lambda_ingress_cidr_blocks" {
  type = list(string)
}

variable "lambda_egress_cidr_blocks" {
  type = list(string)
}
