terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.0"
    }
    dockerless = {
      source  = "nullstone-io/dockerless"
      version = "0.1.1"
    }
  }
}
