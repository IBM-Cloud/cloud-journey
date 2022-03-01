##################################
# IBM Cloud variables
##################################
variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key"
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group to provision resources into"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "ibmcloud_region" {
  type        = string
  description = "Region in which the resources are provisioned. Run `ibmcloud regions` command"
}

variable "prefix" {
  type        = string
  description = "A unique prefix to the assets."
  default     = "ibmcloud-journey"
}

variable "ibmcloud_timeout" {
  type        = number
  description = "IBM Cloud timeout value"
  default     = 600
}

variable "tags" {
  type        = list(string)
  description = "List of tags to be mapped to the resources"
  default     = ["cloud-journey", "vpc"]
}


################################################
# IBM Cloud Kubernetes service(IKS) variables
#################################################

variable "worker_pool_flavor" {
  type        = string
  description = "Flavors determine how much virtual CPU, memory, and disk space is available to each worker node."
  default     = "bx2.4x16"
}

variable "worker_count" {
  type        = string
  description = "Number of worker nodes per zone"
  default     = "1"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the cluster, Run `ibmcloud ks versions`"
  default     = "1.21.9"
}

variable "disable_public_service_endpoint" {
  type        = bool
  description = "Set to true to disable the public service endpoints"
  default     = false
}

variable "create_IKS_cluster" {
  type        = bool
  description = "Creates a IKS cluster in VPC"
  default     = false
}

