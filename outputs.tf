output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "alb_sg_id" {
  value = module.alb_sg.alb_sg_id
}

output "eks_node_sg_id" {
  value = module.eks_node_sg.eks_node_sg_id
}
