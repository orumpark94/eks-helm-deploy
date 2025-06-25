# AWS Region
variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-northeast-2"
}

# 공통 이름 접두사
variable "name" {
  description = "Prefix name for all AWS resources"
  type        = string
  default     = "eks-gitops"
}

# VPC CIDR 블록
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# 퍼블릭 서브넷 CIDR
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# 프라이빗 서브넷 CIDR
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

# 사용할 AZ 목록
variable "availability_zones" {
  description = "Availability zones to deploy subnets"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

# ALB가 연결할 포트
variable "app_port" {
  description = "Application port exposed by the ALB"
  type        = number
  default     = 30000
}
