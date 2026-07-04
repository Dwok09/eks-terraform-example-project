terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.3.0"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  environment = "dev"
  vpc_cidr    = "10.20.0.0/16"
  subnet_cidr = "10.20.20.0/24"
}