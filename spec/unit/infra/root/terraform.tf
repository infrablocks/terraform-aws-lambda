terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}
