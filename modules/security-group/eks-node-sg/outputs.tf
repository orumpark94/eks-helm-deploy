output "eks_node_sg_id" {
  description = "EKS Node security group ID"
  value       = aws_security_group.eks_nodes.id
}
