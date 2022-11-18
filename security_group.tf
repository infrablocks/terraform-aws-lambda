resource "aws_security_group" "lambda_security_group" {
  description = "${var.deployment_identifier}-lambda"
  vpc_id      = var.vpc_id
  tags        = local.resolved_tags
  count       = var.include_vpc_access ? 1 : 0
}

resource "aws_security_group_rule" "ingress" {
  count             = var.include_vpc_access ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.lambda_ingress_cidr_blocks
  security_group_id = aws_security_group.lambda_security_group[0].id
}

resource "aws_security_group_rule" "egress" {
  count             = var.include_vpc_access ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.lambda_egress_cidr_blocks
  security_group_id = aws_security_group.lambda_security_group[0].id
}
