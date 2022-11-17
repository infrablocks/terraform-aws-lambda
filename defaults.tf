locals {
  # default for cases when `null` value provided, meaning "use default"
  vpc_id                                = var.vpc_id == null ? "" : var.vpc_id
  lambda_subnet_ids                     = var.lambda_subnet_ids == null ? [] : var.lambda_subnet_ids
  lambda_ingress_cidr_blocks            = var.lambda_ingress_cidr_blocks == null ? [] : var.lambda_ingress_cidr_blocks
  lambda_egress_cidr_blocks             = var.lambda_egress_cidr_blocks == null ? [] : var.lambda_egress_cidr_blocks
  lambda_runtime                        = var.lambda_runtime == null ? "nodejs14.x" : var.lambda_runtime
  lambda_timeout                        = var.lambda_timeout == null ? 30 : var.lambda_timeout
  lambda_memory_size                    = var.lambda_memory_size == null ? 128 : var.lambda_memory_size
  lambda_reserved_concurrent_executions = var.lambda_reserved_concurrent_executions == null ? -1 : var.lambda_reserved_concurrent_executions
  lambda_execution_role_policy          = var.lambda_execution_role_policy == null ? "" : var.lambda_execution_role_policy
  lambda_assume_role_policy             = var.lambda_assume_role_policy == null ? "" : var.lambda_assume_role_policy
  deploy_in_vpc                         = var.deploy_in_vpc == null ? "yes" : var.deploy_in_vpc
  publish                               = var.publish == null ? "no" : var.publish
  tags                                  = var.tags == null ? {} : var.tags
}
