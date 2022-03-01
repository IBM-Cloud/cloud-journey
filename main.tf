data ibm_resource_group resource_group {
  name = var.resource_group
}

###########################################################
# Module to create a VPC, subnets in 3 zones with ACL rules
###########################################################

module "multizone-vpc-bastion-subnet" {
  source              = "./multizone-vpc-bastion-subnet"
  ibmcloud_api_key    = var.ibmcloud_api_key
  prefix              = var.prefix
  region              = var.ibmcloud_region
  resource_group      = var.resource_group
  use_public_gateways = local.use_public_gateways
  network_acls        = local.network_acls
}


###########################################################
# Module to a multiizone IBM Cloud Kubernetes Cluster
###########################################################

module "vpc_kubernetes_cluster" {
  count = var.create_IKS_cluster ? 1 : 0
  source = "terraform-ibm-modules/cluster/ibm//modules/vpc-kubernetes"
  cluster_name                    = "${var.prefix}-cluster"
  vpc_id                          = module.multizone-vpc-bastion-subnet.vpc_id
  worker_pool_flavor              = var.worker_pool_flavor
  worker_zones                    = local.worker_zones //tomap(ibm_is_subnet.subnet.*.name,tomap(ibm_is_subnet.subnet.*.id)) //var.worker_zones
  worker_nodes_per_zone           = var.worker_count
  resource_group_id               = data.ibm_resource_group.resource_group.id
  kube_version                    = var.kubernetes_version
  disable_public_service_endpoint = var.disable_public_service_endpoint
  tags                            = var.tags
}

###########################################################
# Creates a multizone Application Load Balancer
###########################################################

resource "ibm_container_vpc_alb_create" "alb" {
  count             = var.create_IKS_cluster ? 1 : 0
  cluster           = "${var.prefix}-cluster"
  type              = var.disable_public_service_endpoint ? "private" : "public"
  zone              = "${var.ibmcloud_region}-1"
  resource_group_id = data.ibm_resource_group.resource_group.id
  enable            = "true"
  depends_on = [
    module.vpc_kubernetes_cluster
  ]
}

locals {
  worker_zones = {
    for subnet in module.multizone-vpc-bastion-subnet.subnet_zone_list : subnet.zone => { "subnet_id" = subnet.id }
    if !can(regex("bastion", subnet.name))
  }

  allow_all_inbound = {
    name        = "allow-all-inbound"
    action      = "allow"
    direction   = "inbound"
    destination = "0.0.0.0/0"
    source      = "0.0.0.0/0"
  }
  allow_all_outbound = {
    name        = "allow-all-outbound"
    action      = "allow"
    direction   = "outbound"
    destination = "0.0.0.0/0"
    source      = "0.0.0.0/0"
  }
  use_public_gateways = {
    zone-1 = true
    zone-2 = true
    zone-3 = true
  }

  network_acls = [
    {
      name                = "vpc-acl"
      network_connections = ["bastion"]
      rules = [
        local.allow_all_inbound,
        local.allow_all_outbound
      ]
    },
    {
      name                = "bastion-acl"
      network_connections = ["vpc"]
      rules = [
        local.allow_all_inbound,
        local.allow_all_outbound
      ]
    }
  ]

}
