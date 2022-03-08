##################################
# IBM Cloud variables
##################################
variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key"
  sensitive   = true
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC to provision the IKS cluster"
}

variable "resource_group" {
  description = "Name of resource group to provision resources into"
  type        = string

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-zA-Z]|[a-zA-Z][-a-zA-Z0-9]*[a-zA-Z0-9])$", var.resource_group))
  }
}

variable "ibmcloud_region" {
  type        = string
  description = "Region in which the resources are provisioned. Run `ibmcloud regions` command"
  default     = "us-south"
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = "cloud-journey"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-zA-Z]|[a-zA-Z][-a-zA-Z0-9]*[a-zA-Z0-9])$", var.prefix))
  }
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
  default     = "1.22.7"
}

variable "disable_public_service_endpoint" {
  type        = bool
  description = "Set to true to disable the public service endpoints"
  default     = false
}

