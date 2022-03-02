output "kubernetes_vpc_cluster_id" {
  description = "The ID of the IKS cluster"
  value       = module.vpc_kubernetes_cluster.kubernetes_vpc_cluster_id
}