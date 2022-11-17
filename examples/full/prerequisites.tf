module "base_network" {
  source  = "infrablocks/base-networking/aws"
  version = "4.0.0"

  region = var.region
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones

  component = var.component
  deployment_identifier = var.deployment_identifier

  include_route53_zone_association = "no"
}
