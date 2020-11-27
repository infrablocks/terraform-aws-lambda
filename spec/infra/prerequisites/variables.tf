variable "region" {}
variable "component" {}
variable "deployment_identifier" {}

variable "vpc_cidr" {}
variable "availability_zones" {
  type = list(string)
}
variable "private_zone_id" {}

variable "tags" {
  description = "AWS tags to use on created infrastructure components"
  type = map(string)
  default = {
    "Name" = "terraform-aws-lambda-test-prerequisites"
  }
}
