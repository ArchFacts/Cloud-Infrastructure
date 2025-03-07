terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block               = var.vpc_cidr
  vpc_name                 = var.vpc_name
  public_subnet_cidrs      = var.public_subnets
  private_subnet_cidrs     = var.private_subnets
  nat_gateway_enabled      = var.enable_nat_gateway
  nat_gateway_subnet_index = var.nat_gateway_subnet_index
}

module "ec2_public" {
  source = "./modules/ec2"

  instance_name          = var.instance_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  public_instance_count  = var.public_instance_count
  private_instance_count = var.private_instance_count
  subnet_id_public       = module.vpc.public_subnet_ids[0]
  subnet_id_private      = module.vpc.private_subnet_ids[0]
  key_name               = var.key_name
}
