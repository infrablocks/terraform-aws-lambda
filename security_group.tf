resource "aws_security_group" "sg_lambda" {
  description = "${var.deployment_identifier}-lambda"
  vpc_id = local.vpc_id
  tags = local.resolved_tags
  count = (var.deploy_in_vpc == null ? "yes" : var.deploy_in_vpc) == "yes" ? 1 : 0

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.lambda_ingress_cidr_blocks
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = local.lambda_egress_cidr_blocks
  }
}
