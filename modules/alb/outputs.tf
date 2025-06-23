output "alb_dns_name" {
  description = "Public DNS of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_sg_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.tg.arn
}

output "app_target_port" {
  value = var.target_port
}
