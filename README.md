# vpc-multizone-iks-lb

:construction: Work in Progress

Provision a multizone IBM Cloud Kubernetes service (IKS) cluster on a Virtual private cloud (VPC) with a load balancer.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.39.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_multizone-vpc-bastion-subnet"></a> [multizone-vpc-bastion-subnet](#module\_multizone-vpc-bastion-subnet) | ./multizone-vpc-bastion-subnet | n/a |
| <a name="module_vpc_kubernetes_cluster"></a> [vpc\_kubernetes\_cluster](#module\_vpc\_kubernetes\_cluster) | terraform-ibm-modules/cluster/ibm//modules/vpc-kubernetes | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_container_vpc_alb_create.alb](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/container_vpc_alb_create) | resource |
| [ibm_resource_group.resource_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_IKS_cluster"></a> [create\_IKS\_cluster](#input\_create\_IKS\_cluster) | Creates a IKS cluster in VPC | `bool` | `false` | no |
| <a name="input_disable_public_service_endpoint"></a> [disable\_public\_service\_endpoint](#input\_disable\_public\_service\_endpoint) | Set to true to disable the public service endpoints | `bool` | `false` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API key | `string` | n/a | yes |
| <a name="input_ibmcloud_region"></a> [ibmcloud\_region](#input\_ibmcloud\_region) | Region in which the resources are provisioned. Run `ibmcloud regions` command | `string` | `"us-south"` | no |
| <a name="input_ibmcloud_timeout"></a> [ibmcloud\_timeout](#input\_ibmcloud\_timeout) | IBM Cloud timeout value | `number` | `600` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the cluster, Run `ibmcloud ks versions` | `string` | `"1.21.9"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique prefix to the assets. | `string` | `"ibmcloud-journey"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Name of the resource group to provision resources into | `string` | `"cloud-journey"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be mapped to the resources | `list(string)` | <pre>[<br>  "cloud-journey",<br>  "vpc"<br>]</pre> | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Number of worker nodes per zone | `string` | `"1"` | no |
| <a name="input_worker_pool_flavor"></a> [worker\_pool\_flavor](#input\_worker\_pool\_flavor) | Flavors determine how much virtual CPU, memory, and disk space is available to each worker node. | `string` | `"bx2.4x16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_IKS_cluster_id"></a> [IKS\_cluster\_id](#output\_IKS\_cluster\_id) | IKS cluster ID |
| <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer) | Load balancer details |
| <a name="output_subnet_detail_list"></a> [subnet\_detail\_list](#output\_subnet\_detail\_list) | A list of subnets containing names, CIDR blocks, and zones. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | Name of the provisioned VPC |
