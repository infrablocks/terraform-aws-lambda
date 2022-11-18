variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "vpc_id" {
  default = null
}

variable "lambda_function_name" {}
variable "lambda_description" {}

variable "lambda_package_type" {
  default = null
}

variable "lambda_zip_path" {
  default = null
}
variable "lambda_handler" {
  default = null
}
variable "lambda_runtime" {
  default = null
}

variable "lambda_image_uri" {
  default = null
}

variable "lambda_image_config" {
  type = object({
    command: optional(list(string)),
    working_directory: optional(string),
    entry_point: optional(list(string))
  })
  default = {}
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
variable "lambda_execution_role_policy_document" {
  default = null
}
variable "lambda_execution_role_source_policy_document" {
  default = null
}
variable "lambda_assume_role_policy_document" {
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

variable "include_vpc_access" {
  type = bool
  default = null
}
variable "include_execution_role_policy_vpc_access_management_statement" {
  type = bool
  default = null
}
variable "include_execution_role_policy_log_management_statement" {
  type = bool
  default = null
}
variable "publish" {
  type = bool
  default = null
}
