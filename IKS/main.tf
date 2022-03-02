data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

###########################################################
# Module to a multiizone IBM Cloud Kubernetes Cluster
###########################################################

module "vpc_kubernetes_cluster" {
  source                          = "terraform-ibm-modules/cluster/ibm//modules/vpc-kubernetes"
  cluster_name                    = "${var.prefix}-cluster"
  vpc_id                          = data.ibm_is_vpc.vpc.id
  worker_pool_flavor              = var.worker_pool_flavor
  worker_zones                    = local.worker_zones
  worker_nodes_per_zone           = var.worker_count
  resource_group_id               = data.ibm_resource_group.resource_group.id
  kube_version                    = var.kubernetes_version
  disable_public_service_endpoint = var.disable_public_service_endpoint
  tags                            = var.tags
}

###########################################################
# Creates a multizone Application Load Balancer
###########################################################

/*resource "ibm_container_vpc_alb_create" "alb" {
  cluster           = "${var.prefix}-cluster"
  type              = var.disable_public_service_endpoint ? "private" : "public"
  zone              = "${var.ibmcloud_region}-1"
  resource_group_id = data.ibm_resource_group.resource_group.id
  enable            = "true"
  depends_on = [
    module.vpc_kubernetes_cluster
  ]
}*/

locals {
  worker_zones = {
    for subnet in data.ibm_is_vpc.vpc.subnets: subnet.zone => { "subnet_id" = subnet.id }
    if !can(regex("bastion", subnet.name))
  }
}
