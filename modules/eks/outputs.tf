output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_role_arn" {
  description = "IAM Role ARN used by EKS worker nodes"
  value       = aws_iam_role.node_group_role.arn
}
