variable "name" {
  description = "Name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port your app is listening on (e.g., 3000 for Node.js)"
  type        = number
}

variable "alb_sg_id" {
  description = "ALB security group ID (from external SG module)"
  type        = string
}