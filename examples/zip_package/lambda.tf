module "lambda" {
  source = "../../"

  region = var.region

  component             = var.component
  deployment_identifier = var.deployment_identifier

  lambda_function_name = "test-lambda-resource-${var.deployment_identifier}"
  lambda_description   = "test terraform-aws-lambda"

  lambda_zip_path = "${path.root}/lambda.zip"
  lambda_handler  = "handler.hello"
  lambda_runtime  = "nodejs16.x"

  lambda_environment_variables = {
    "TEST_ENV_VARIABLE" : "value"
  }

  tags = {
    Important : "tag"
  }
}
