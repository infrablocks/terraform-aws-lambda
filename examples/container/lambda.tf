module "lambda" {
  source = "../../"

  region = var.region

  component             = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = "test-lambda-resource-${var.deployment_identifier}"
  lambda_description   = "test terraform-aws-lambda"

  lambda_package_type = "Image"
  lambda_image_uri = local.image_uri

  lambda_environment_variables = {
    "TEST_ENV_VARIABLE" : "value"
  }

  tags = {
    Important : "tag"
  }
}
