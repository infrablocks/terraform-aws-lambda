# Component / Service & AWS Account Settings

variable "region" {
  description = "The region into which to deploy the Lambda."
  type        = string
}

variable "component" {
  description = "The name of the component or service"
  type        = string
}

variable "deployment_identifier" {
  description = "An identifier for this instantiation e.g. <deployment_type>-<deployment_label>"
  type        = string
}

# Lambda Settings

variable "lambda_function_name" {
  description = "The name to use for the lambda function"
  type        = string
}

variable "lambda_description" {
  description = "The description to use for the AWS Lambda"
  type        = string
}

variable "lambda_package_type" {
  description = "The lambda deployment package type. Valid values are \"Zip\" and \"Image\". Defaults to \"Zip\"."
  type        = string
  default     = "Zip"
  nullable    = false
}

variable "lambda_zip_path" {
  description = "The location where the generated zip file should be stored. Required when `lambda_package_type` is \"Zip\"."
  type        = string
  default     = null
}

variable "lambda_handler" {
  description = "The name of the handler to use for the lambda function. Required when `lambda_package_type` is \"Zip\"."
  type        = string
  default     = null
}

variable "lambda_runtime" {
  description = "The runtime to use for the lambda function"
  type        = string
  default     = "nodejs14.x"
  nullable    = false
}

variable "lambda_image_uri" {
  description = "The ECR image URI containing the function's deployment package. Required when `lambda_package_type` is \"Image\"."
  type        = string
  default     = null
}

variable "lambda_image_config" {
  description = "Container image configuration values that override the values in the container image Dockerfile."
  type = object({
    command: string,
    entry_point: string,
    working_directory: string
  })
  default = {
    command: null,
    entry_point: null,
    working_directory: null
  }
}

variable "lambda_timeout" {
  description = "The timeout period to use for the lambda function"
  default     = 30
  nullable    = false
}

variable "lambda_memory_size" {
  description = "The amount of memeory to use for the lambda function"
  default     = 128
  nullable    = false
}

variable "lambda_reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function"
  default     = -1
  nullable    = false
}

variable "lambda_execution_role_policy" {
  description = "The inline AWS execution role policy to use for the lambda."
  type        = string
  default     = ""
  nullable    = false
}

variable "lambda_assume_role_policy" {
  description = "An inline AWS role policy which the lambda should assume during execution."
  type        = string
  default     = ""
  nullable    = false
}

variable "lambda_environment_variables" {
  description = "Environment variables to be provided to the lambda function."
  type        = map(string)
  default     = null
}

variable "tags" {
  description = "AWS tags to use on created infrastructure components"
  type        = map(string)
  default     = {}
  nullable    = false
}

# Deployment Options

variable "include_vpc_access" {
  description = "Whether or not to allow the lambda to access a VPC."
  type        = bool
  default     = false
  nullable    = false
}

variable "publish" {
  description = "Whether or not to publish creation / change as a new lambda function version."
  type        = bool
  default     = false
  nullable    = false
}

# VPC Deployment Settings

variable "vpc_id" {
  description = "The ID of the VPC into which to deploy the lambda."
  type        = string
  default     = ""
  nullable    = false
}

variable "lambda_subnet_ids" {
  description = "The IDs of the subnets for the lambda"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "lambda_ingress_cidr_blocks" {
  description = "The ingress CIDR ranges to allow access"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "lambda_egress_cidr_blocks" {
  description = "The egress CIDR ranges to allow access"
  type        = list(string)
  default     = []
  nullable    = false
}
