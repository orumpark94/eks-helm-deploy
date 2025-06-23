variable "name" {
  description = "Name prefix"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS cluster"
  type        = list(string)
}

variable "target_port" {
  description = "Application port exposed by your Node.js app"
  type        = number
}

# modules/eks/variables.tf

variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}