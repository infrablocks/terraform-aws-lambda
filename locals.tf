locals {
  base_tags = {
    Component: var.component,
    DeploymentIdentifier: var.deployment_identifier
  }

  resolved_tags = merge(local.tags, local.base_tags)
}
