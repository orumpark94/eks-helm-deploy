variable "vpc_id" {
  description = "VPC ID for EKS Node SG"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB SG ID to allow traffic from"
  type        = string
}
