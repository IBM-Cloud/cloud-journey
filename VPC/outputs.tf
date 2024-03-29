##############################################################################
# VPC GUID
##############################################################################

output "vpc_name" {
  description = "Name of the VPC created"
  value       = ibm_is_vpc.vpc.name
}

##############################################################################

##############################################################################
# Subnet Outputs
# Copyright 2022 IBM
##############################################################################

output "subnet_detail_list" {
  description = "A list of subnets containing names, CIDR blocks, and zones."
  value       = module.subnets.detail_list
}

##############################################################################