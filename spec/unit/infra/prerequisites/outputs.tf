output "vpc_id" {
  value = module.base_network.vpc_id
}

output "vpc_cidr" {
  value = module.base_network.vpc_cidr
}

output "public_subnet_ids" {
  value = module.base_network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.base_network.private_subnet_ids
}

output "registry_id" {
  value = aws_ecr_repository.test.registry_id
}

output "repository_url" {
  value = aws_ecr_repository.test.repository_url
}