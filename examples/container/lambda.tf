module "lambda" {
  source = "../../"

  region = var.region
  vpc_id = module.base_network.vpc_id

  component             = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = "test-lambda-resource-${var.deployment_identifier}"
  lambda_description   = "test terraform-aws-lambda"

  lambda_package_type = "Image"
  lambda_image_uri = local.image_uri

  lambda_environment_variables = {
    "TEST_ENV_VARIABLE" : "value"
  }

  include_vpc_access         = true
  lambda_subnet_ids          = module.base_network.private_subnet_ids
  lambda_ingress_cidr_blocks = ["0.0.0.0/0"]
  lambda_egress_cidr_blocks  = [var.vpc_cidr]

  tags = {
    Important : "tag"
  }
}
