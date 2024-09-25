terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}


provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = var.project_name
    }
  }
}
