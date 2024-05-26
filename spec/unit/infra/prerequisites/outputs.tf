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

output "image_uri" {
  value = "${aws_ecr_repository.test.repository_url}@${data.aws_ecr_image.test.image_digest}"
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.test.name
}
