locals {
  base_tags = {
    "Component" = var.component,
    "DeploymentType" = var.deployment_type,
    "DeploymentLabel" = var.deployment_label,
    "DeploymentIdentifier" = var.deployment_identifier
  }

  tags = merge(var.tags, local.base_tags)
}
