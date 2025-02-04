output "eks_cluster_name" {
  description = "The EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "The EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

#output "wordpress_url" {
#  description = "WordPress LoadBalancer URL"
#  value       = helm_release.wordpress.status["load_balancer"].ingress[0].hostname
#}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}
