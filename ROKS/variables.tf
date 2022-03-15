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
# Red Hat OpenShift on IBM Cloud variables
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
  default     = "4.8_openshift"
}

variable "disable_public_service_endpoint" {
  type        = bool
  description = "Set to true to disable the public service endpoints"
  default     = false
}

variable "update_all_workers" {
  description = "set to true, the Kubernetes version of the worker nodes is updated along with the Kubernetes version of the cluster that you specify in kube_version."
  type        = bool
  default     = true
}

variable "entitlement" {
  type        = string
  description = "Entitlement reduces additional OCP Licence cost in OpenShift clusters. Use Cloud Pak with OCP Licence entitlement to create the OpenShift cluster."
  default     = "cloud_pak"
}

variable "service_subnet" {
  description = "Specify a custom subnet CIDR to provide private IP addresses for services."
  type        = string
  default     = null
}

variable "pod_subnet" {
  description = "Specify a custom subnet CIDR to provide private IP addresses for pods."
  type        = string
  default     = null
}

variable "worker_labels" {
  description = "Labels on all the workers in the default worker pool."
  type        = map
  default     = null
}

variable "wait_till" {
  description = "specify the stage when Terraform to mark the cluster creation as completed."
  type        = string
  default     = "ingressReady"
}

variable "force_delete_storage" {
  description = "force the removal of persistent storage associated with the cluster during cluster deletion."
  type        = bool
  default     = true
}

variable "kms_config" {
  type        = list(map(string))
  description = "key protect configurations"
  default     = []
}

variable "taints" {
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  description = "Set taints to worker nodes."
  default = [{
    key    = "dedicated"
    value  = "edge"
    effect = "NoSchedule"
    },
  ]
}