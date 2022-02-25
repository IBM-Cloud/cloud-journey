//******************************************
// Creates a resource group
//******************************************
data "ibm_resource_group" "group" {
  name  = var.resource_group
}

//******************************************
// Creates a Virtual Private Cloud
//******************************************

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

/*resource "ibm_is_vpc" "vpc" {
  name           = "${var.prefix}-vpc"
  resource_group = ibm_resource_group.group.id
}


resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  count = 3

  name = "${var.prefix}-zone-${count.index + 1}"
  zone = "${var.ibmcloud_region}-${(count.index % 3) + 1}"
  vpc  = ibm_is_vpc.vpc.id
  cidr = element(var.cidr_blocks, count.index)
}

resource "ibm_is_public_gateway" "gateway" {
  count          = 3

  name           = "${var.prefix}-gateway-${count.index + 1}"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.ibmcloud_region}-${count.index + 1}"
  resource_group = ibm_resource_group.group.id
}

resource "ibm_is_subnet" "subnet" {
  count = 3

  name            = "${var.prefix}-subnet-${count.index + 1}"
  vpc             = ibm_is_vpc.vpc.id
  resource_group  = ibm_resource_group.group.id
  zone            = "${var.ibmcloud_region}-${count.index + 1}"
  total_ipv4_address_count = "256"
  #ipv4_cidr_block = element(ibm_is_vpc_address_prefix.subnet_prefix.*.cidr, count.index)
  public_gateway  = (ibm_is_public_gateway.gateway[count.index].zone == "${var.ibmcloud_region}-${count.index + 1}") ? ibm_is_public_gateway.gateway[count.index].id : ibm_is_public_gateway.gateway[count.index+1].id

}*/


module "vpc_kubernetes_cluster" {
  //Uncomment the following line to make the source point to registry level
  source = "terraform-ibm-modules/cluster/ibm//modules/vpc-kubernetes"
  //source = "../../modules/vpc-kubernetes"
  cluster_name                    = "${var.prefix}-cluster"
  vpc_id                          = data.ibm_is_vpc.vpc.id
  worker_pool_flavor              = var.worker_pool_flavor
  worker_zones                    = local.worker_zones //tomap(ibm_is_subnet.subnet.*.name,tomap(ibm_is_subnet.subnet.*.id)) //var.worker_zones
  worker_nodes_per_zone           = var.worker_count
  resource_group_id               = data.ibm_resource_group.group.id
  kube_version                    = var.kubernetes_version
  disable_public_service_endpoint = var.disable_public_service_endpoint
  tags                            = var.tags
}

resource ibm_container_vpc_alb_create alb {
  cluster = "${var.prefix}-cluster"
  type = var.disable_public_service_endpoint ? "private": "public"
  zone = "${var.ibmcloud_region}-1"
  resource_group_id = data.ibm_resource_group.group.id
  enable = "true"
  depends_on = [
    module.vpc_kubernetes_cluster
  ]
}

locals {
  worker_zones      = { for key, value in zipmap(data.ibm_is_vpc.vpc.subnets.*.zone, data.ibm_is_vpc.vpc.subnets.*.id) : key => { "subnet_id" = value } }
}
