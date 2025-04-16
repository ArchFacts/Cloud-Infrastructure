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
  region  = var.aws_region
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

module "ec2" {
  source = "./modules/ec2"

  instance_name          = var.instance_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  public_instance_count  = var.public_instance_count
  private_instance_count = var.private_instance_count
  subnet_id_public       = module.vpc.public_subnet_ids
  subnet_id_private      = module.vpc.private_subnet_ids
  key_name               = var.key_name
  public_key_content     = file("keys/${var.key_name}.pub")
  sg_public_id           = module.security.sg_public_id
  sg_private_id          = module.security.sg_private_id
}

module "security" {
  source = "./modules/security"

  vpc_id               = module.vpc.vpc_id
  vpc_cidr_block       = module.vpc.vpc_cidr_block
  vpc_name             = var.vpc_name
  instance_name        = var.instance_name
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  private_subnet_cidrs = var.private_subnets
  public_subnet_cidrs  = var.public_subnets
}
