data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "lambda" {
  source = "../../../../"

  region = var.region
  vpc_id = var.vpc_id

  component             = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = var.lambda_function_name
  lambda_description   = var.lambda_description

  lambda_package_type = var.lambda_package_type

  lambda_zip_path = var.lambda_zip_path
  lambda_handler  = var.lambda_handler
  lambda_runtime  = var.lambda_runtime
  lambda_architectures  = var.lambda_architectures

  lambda_image_uri = var.lambda_image_uri

  lambda_image_config = var.lambda_image_config

  lambda_logging_config = var.lambda_logging_config
  lambda_tracing_config = var.lambda_tracing_config

  lambda_environment_variables = var.lambda_environment_variables

  lambda_timeout                        = var.lambda_timeout
  lambda_memory_size                    = var.lambda_memory_size
  lambda_reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  lambda_assume_role_policy_document           = var.lambda_assume_role_policy_document
  lambda_execution_role_policy_document        = var.lambda_execution_role_policy_document
  lambda_execution_role_source_policy_document = var.lambda_execution_role_source_policy_document

  include_execution_role_policy_vpc_access_management_statement = var.include_execution_role_policy_vpc_access_management_statement
  include_execution_role_policy_log_management_statement        = var.include_execution_role_policy_log_management_statement

  include_vpc_access         = var.include_vpc_access
  lambda_subnet_ids          = var.lambda_subnet_ids
  lambda_ingress_cidr_blocks = var.lambda_ingress_cidr_blocks
  lambda_egress_cidr_blocks  = var.lambda_egress_cidr_blocks

  publish = var.publish

  tags = var.tags
}
