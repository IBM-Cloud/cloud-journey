## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.39.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_openshift_cluster"></a> [vpc\_openshift\_cluster](#module\_vpc\_openshift\_cluster) | terraform-ibm-modules/cluster/ibm//modules/vpc-openshift | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_resource_instance.cos_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_is_vpc.vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/is_vpc) | data source |
| [ibm_resource_group.resource_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_disable_public_service_endpoint"></a> [disable\_public\_service\_endpoint](#input\_disable\_public\_service\_endpoint) | Set to true to disable the public service endpoints | `bool` | `false` | no |
| <a name="input_entitlement"></a> [entitlement](#input\_entitlement) | Entitlement reduces additional OCP Licence cost in OpenShift clusters. Use Cloud Pak with OCP Licence entitlement to create the OpenShift cluster. | `string` | `"cloud_pak"` | no |
| <a name="input_force_delete_storage"></a> [force\_delete\_storage](#input\_force\_delete\_storage) | force the removal of persistent storage associated with the cluster during cluster deletion. | `bool` | `true` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | IBM Cloud API key | `string` | n/a | yes |
| <a name="input_ibmcloud_region"></a> [ibmcloud\_region](#input\_ibmcloud\_region) | Region in which the resources are provisioned. Run `ibmcloud regions` command | `string` | `"us-south"` | no |
| <a name="input_ibmcloud_timeout"></a> [ibmcloud\_timeout](#input\_ibmcloud\_timeout) | IBM Cloud timeout value | `number` | `600` | no |
| <a name="input_kms_config"></a> [kms\_config](#input\_kms\_config) | key protect configurations | `list(map(string))` | `[]` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the cluster, Run `ibmcloud ks versions` | `string` | `"4.8_openshift"` | no |
| <a name="input_pod_subnet"></a> [pod\_subnet](#input\_pod\_subnet) | Specify a custom subnet CIDR to provide private IP addresses for pods. | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique identifier need to provision resources. Must begin with a letter | `string` | `"cloud-journey"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Name of resource group to provision resources into | `string` | n/a | yes |
| <a name="input_service_subnet"></a> [service\_subnet](#input\_service\_subnet) | Specify a custom subnet CIDR to provide private IP addresses for services. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to be mapped to the resources | `list(string)` | <pre>[<br>  "cloud-journey",<br>  "vpc"<br>]</pre> | no |
| <a name="input_taints"></a> [taints](#input\_taints) | Set taints to worker nodes. | <pre>list(object({<br>    key    = string<br>    value  = string<br>    effect = string<br>  }))</pre> | <pre>[<br>  {<br>    "effect": "NoSchedule",<br>    "key": "dedicated",<br>    "value": "edge"<br>  }<br>]</pre> | no |
| <a name="input_update_all_workers"></a> [update\_all\_workers](#input\_update\_all\_workers) | set to true, the Kubernetes version of the worker nodes is updated along with the Kubernetes version of the cluster that you specify in kube\_version. | `bool` | `true` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC to provision the IKS cluster | `string` | n/a | yes |
| <a name="input_wait_till"></a> [wait\_till](#input\_wait\_till) | specify the stage when Terraform to mark the cluster creation as completed. | `string` | `"ingressReady"` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Number of worker nodes per zone | `string` | `"1"` | no |
| <a name="input_worker_labels"></a> [worker\_labels](#input\_worker\_labels) | Labels on all the workers in the default worker pool. | `map` | `null` | no |
| <a name="input_worker_pool_flavor"></a> [worker\_pool\_flavor](#input\_worker\_pool\_flavor) | Flavors determine how much virtual CPU, memory, and disk space is available to each worker node. | `string` | `"bx2.4x16"` | no |

## Outputs

No outputs.
