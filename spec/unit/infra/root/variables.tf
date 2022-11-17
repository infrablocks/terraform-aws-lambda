variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "vpc_id" {
  default = null
}

variable "lambda_function_name" {}
variable "lambda_description" {}

variable "lambda_zip_path" {}
variable "lambda_handler" {}

variable "lambda_runtime" {
  default = null
}
variable "lambda_timeout" {
  default = null
}
variable "lambda_memory_size" {
  default = null
}
variable "lambda_reserved_concurrent_executions" {
  default = null
}
variable "lambda_execution_role_policy" {
  default = null
}
variable "lambda_assume_role_policy" {
  default = null
}

variable "lambda_environment_variables" {
  type    = map(string)
  default = null
}

variable "lambda_subnet_ids" {
  type    = list(string)
  default = null
}
variable "lambda_ingress_cidr_blocks" {
  type    = list(string)
  default = null
}
variable "lambda_egress_cidr_blocks" {
  type    = list(string)
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "deploy_in_vpc" {
  type = bool
  default = null
}
variable "publish" {
  type = bool
  default = null
}
