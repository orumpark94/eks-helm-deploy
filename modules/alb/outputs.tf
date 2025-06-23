output "alb_dns_name" {
  description = "Public DNS of the ALB"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "app_target_port" {
  value = var.target_port
}

output "alb_sg_id" {
  description = "ID of the externally provided ALB Security Group"
  value       = var.alb_sg_id
}