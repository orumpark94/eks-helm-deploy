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

# 1. VPC 생성
module "vpc" {
  source               = "./modules/vpc"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# 2. ALB용 SG 모듈
module "alb_sg" {
  source = "./modules/security-group/alb-sg"
  vpc_id = module.vpc.vpc_id
}

# 3. EKS Node용 SG 모듈
module "eks_node_sg" {
  source     = "./modules/security-group/eks-node-sg"
  vpc_id     = module.vpc.vpc_id
  alb_sg_id  = module.alb_sg.alb_sg_id
}

# 4. ALB 모듈 (보안 그룹 주입)
module "alb" {
  source            = "./modules/alb"
  name              = var.name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.alb_sg.alb_sg_id   # ✅ 주입
  target_port       = var.app_port              # ex: 3000
}

# 5. EKS 모듈
module "eks" {
  source             = "./modules/eks"
  name               = var.name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  target_port        = var.app_port
}
