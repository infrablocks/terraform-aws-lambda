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
output "lambda_invoke_arn" {
  value = module.lambda.lambda_invoke_arn
}
output "lambda_arn" {
  value = module.lambda.lambda_arn
}
output "lambda_qualified_arn" {
  value = module.lambda.lambda_qualified_arn
}
output "lambda_function_name" {
  value = module.lambda.lambda_function_name
}
output "lambda_last_modified" {
  value = module.lambda.lambda_last_modified
}
output "lambda_id" {
  value = module.lambda.lambda_id
}
output "lambda_memory_size" {
  value = module.lambda.lambda_memory_size
}
output "lambda_image_uri" {
  value = module.lambda.lambda_image_uri
}
output "lambda_version" {
  value = module.lambda.lambda_version
}
output "security_group_name" {
  value = module.lambda.security_group_name
}
output "iam_role_name" {
  value = module.lambda.iam_role_name
}
output "iam_role_policy_name" {
  value = module.lambda.iam_role_policy_name
}
