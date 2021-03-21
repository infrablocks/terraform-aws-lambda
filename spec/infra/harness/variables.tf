variable "region" {}
variable "component" {}
variable "deployment_identifier" {}
variable "deployment_label" {}
variable "deployment_type" {}

variable "account_id" {}

variable "lambda_function_name" {}
variable "lambda_description" {}

variable "lambda_zip_path" {}
variable "lambda_handler" {}

variable "lambda_environment_variables" {
  type = map(string)
}

variable "lambda_ingress_cidr_blocks" {
  type = list(string)
}
variable "lambda_egress_cidr_blocks" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "deploy_in_vpc" {}
