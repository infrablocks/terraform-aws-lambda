module "base_network" {
  source  = "infrablocks/base-networking/aws"
  version = "4.0.0"

  region             = var.region
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  component             = var.component
  deployment_identifier = var.deployment_identifier

  include_route53_zone_association = "no"
}

resource "aws_ecr_repository" "test" {
  name = "test/${var.component}-${var.deployment_identifier}"
  force_delete = true
}

resource "dockerless_remote_image" "test" {
  source = "nginx:latest"
  target = "${aws_ecr_repository.test.repository_url}:latest"
}

data "aws_ecr_image" "test" {
  repository_name = "test/${var.component}-${var.deployment_identifier}"
  image_tag       = "latest"

  depends_on = [
    dockerless_remote_image.test
  ]
}
