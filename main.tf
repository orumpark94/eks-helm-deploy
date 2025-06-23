provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.5.0"
  backend "s3" {
    bucket = "eks-terrafrom"
    key    = "eks/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "alb" {
  source            = "./modules/alb"
  name              = var.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_port       = var.app_port
}

module "eks" {
  source             = "./modules/eks"
  name               = var.name
  vpc_id             = module.vpc.vpc_id     # ✅ 이 줄 추가
  private_subnet_ids = module.vpc.private_subnet_ids
  target_port        = var.app_port  
}
