terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22"
    }
    dockerless = {
      source = "nullstone-io/dockerless"
      version = "0.1.1"
    }
  }
}
