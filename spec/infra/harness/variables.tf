variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "account_id" {}

variable "lambda_zip_path" {}
variable "lambda_ingress_cidr_blocks" {
  type = list(string)
}
variable "lambda_egress_cidr_blocks" {
  type = list(string)
}
variable "lambda_environment_variables" {
  type = map(string)
}
variable "lambda_function_name" {}
variable "lambda_handler" {}
