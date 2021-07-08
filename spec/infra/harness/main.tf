data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "lambda" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  region = var.region
  account_id = var.account_id
  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id

  component = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = var.lambda_function_name
  lambda_description = var.lambda_description

  lambda_zip_path = var.lambda_zip_path
  lambda_handler = var.lambda_handler

  lambda_environment_variables = var.lambda_environment_variables

  lambda_subnet_ids = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids
  lambda_ingress_cidr_blocks = var.lambda_ingress_cidr_blocks
  lambda_egress_cidr_blocks = var.lambda_egress_cidr_blocks

  deploy_in_vpc = var.deploy_in_vpc
  lambda_reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  tags = var.tags
}
