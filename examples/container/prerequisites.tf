resource "aws_ecr_repository" "test" {
  name = "test/${var.component}-${var.deployment_identifier}"
  force_delete = true
}

resource "dockerless_remote_image" "test" {
  source = "amazon/aws-lambda-nodejs:latest"
  target = "${aws_ecr_repository.test.repository_url}:latest"
}

data "aws_ecr_image" "test" {
  repository_name = "test/${var.component}-${var.deployment_identifier}"
  image_tag       = "latest"

  depends_on = [
    dockerless_remote_image.test
  ]
}

locals {
  image_uri = "${aws_ecr_repository.test.repository_url}@${data.aws_ecr_image.test.image_digest}"
}
