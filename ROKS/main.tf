data "ibm_resource_group" "resource_group" {
  name = var.resource_group
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

resource "ibm_resource_instance" "cos_instance" {
  name     = "${var.prefix}-cos"
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}


###########################################################
# Module to a multizone Red Hat OpenShift on IBM Cloud Cluster
###########################################################

module "vpc_openshift_cluster" {
  source = "terraform-ibm-modules/cluster/ibm//modules/vpc-openshift"

  cluster_name                    = "${var.prefix}-roks-cluster"
  vpc_id                          = data.ibm_is_vpc.vpc.id
  worker_pool_flavor              = var.worker_pool_flavor
  worker_zones                    = local.worker_zones
  worker_nodes_per_zone           = var.worker_count
  resource_group_id               = data.ibm_resource_group.resource_group.id
  kube_version                    = var.kubernetes_version
  update_all_workers              = var.update_all_workers
  service_subnet                  = var.service_subnet
  pod_subnet                      = var.pod_subnet
  worker_labels                   = var.worker_labels
  wait_till                       = var.wait_till
  disable_public_service_endpoint = var.disable_public_service_endpoint
  tags                            = var.tags
  cos_instance_crn                = ibm_resource_instance.cos_instance.id
  force_delete_storage            = var.force_delete_storage
  kms_config                      = var.kms_config
  entitlement                     = var.entitlement
}

locals {
  worker_zones = {
    for subnet in data.ibm_is_vpc.vpc.subnets : subnet.zone => { "subnet_id" = subnet.id }
    if !can(regex("bastion", subnet.name))
  }
}
