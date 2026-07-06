terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", "us-east-1"]
    }
  }
}

module "vpc" {
  source                        = "../../modules/vpc"
  environment                   = var.environment
  vpc_cidr                      = "10.10.0.0/16"
  public_subnet_cidr            = "10.10.1.0/24"
  private_subnet_cidr           = "10.10.2.0/24"
  private_subnet_cidr_secondary = "10.10.3.0/24"
}

module "eks" {
  source              = "../../modules/eks"
  cluster_name        = "${var.environment}-eks"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
}

module "workloads" {
  source = "../../modules/workloads"
}
