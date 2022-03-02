##############################################################################
# Account Variables
# Copyright 2022 IBM
##############################################################################

# Uncomment this variable if running locally
variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
  sensitive   = true
}

variable "resource_group" {
  description = "Name of resource group where all infrastructure will be provisioned"
  type        = string

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
  }
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = "cloud-journey"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
  }
}

variable "ibmcloud_region" {
  description = "Region where VPC will be created"
  type        = string
  default     = "us-south"
}

variable "ibmcloud_timeout" {
  type        = number
  description = "IBM Cloud timeout value"
  default     = 600
}

# Comment out if not running in schematics
variable "TF_VERSION" {
  default     = "1.0"
  type        = string
  description = "The version of the Terraform engine that's used in the Schematics workspace."
}

##############################################################################


##############################################################################
# VPC Variables
##############################################################################

variable "classic_access" {
  description = "Enable VPC Classic Access. Note: only one VPC per ibmcloud_region can have classic access"
  type        = bool
  default     = false
}

variable "subnet_tiers" {
  description = "List of subnets tiers for the vpc."
  /* type        = list(
    object({
      name     = string
      acl_name = string
      subnets  = object({
        zone-1 = list(
          object({
            name           = string
            cidr           = string
            public_gateway = optional(bool)
          })
        )
        zone-2 = list(
          object({
            name           = string
            cidr           = string
            public_gateway = optional(bool)
          })
        )
        zone-3 = list(
          object({
            name           = string
            cidr           = string
            public_gateway = optional(bool)
          })
        )
      })
    })
  )*/
  default = [
    {
      name     = "vpc"
      acl_name = "vpc-acl"
      subnets = {
        zone-1 = [
          {
            name           = "subnet-a"
            cidr           = "10.10.10.0/24"
            public_gateway = true
          }
        ],
        zone-2 = [
          {
            name           = "subnet-b"
            cidr           = "10.20.10.0/24"
            public_gateway = true
          }
        ],
        zone-3 = [
          {
            name           = "subnet-c"
            cidr           = "10.30.10.0/24"
            public_gateway = true
          }
        ]
      }
    },
    {
      name     = "bastion"
      acl_name = "bastion-acl"
      subnets = {
        zone-1 = [
          {
            name           = "subnet-a"
            cidr           = "10.40.10.0/24"
            public_gateway = false
          }
        ]
        zone-2 = []
        zone-3 = []
      }
    }
  ]

  validation {
    error_message = "Keys for `subnets` objects in each tier must be in the order `zone-1`, `zone-2`, `zone-3`."
    condition = length(
      distinct(
        flatten([
          for tier in var.subnet_tiers :
          false if keys(tier.subnets)[0] != "zone-1" || keys(tier.subnets)[1] != "zone-2" || keys(tier.subnets)[2] != "zone-3"
        ])
      )
    ) == 0
  }

  validation {
    error_message = "Each tier must have a unique name."
    condition     = length(distinct(var.subnet_tiers.*.name)) == length(var.subnet_tiers)
  }
}

variable "use_public_gateways" {
  description = "Create a public gateway in any of the three zones with `true`."
  type = object({
    zone-1 = optional(bool)
    zone-2 = optional(bool)
    zone-3 = optional(bool)
  })
  default = {
    zone-1 = true
    zone-2 = true
    zone-3 = true
  }

  validation {
    error_message = "Keys for `use_public_gateways` must be in the order `zone-1`, `zone-2`, `zone-3`."
    condition     = keys(var.use_public_gateways)[0] == "zone-1" && keys(var.use_public_gateways)[1] == "zone-2" && keys(var.use_public_gateways)[2] == "zone-3"
  }
}

variable "network_acls" {
  description = "List of ACLs to create. Rules can be automatically created to allow inbound and outbound traffic from a VPC tier by adding the name of that tier to the `network_connections` list. Rules automatically generated by these network connections will be added at the beginning of a list, and will be web-tierlied to traffic first. At least one rule must be provided for each ACL."
  type = list(
    object({
      name                = string
      network_connections = optional(list(string))
      rules = list(
        object({
          name        = string
          action      = string
          destination = string
          direction   = string
          source      = string
          tcp = optional(
            object({
              port_max        = optional(number)
              port_min        = optional(number)
              source_port_max = optional(number)
              source_port_min = optional(number)
            })
          )
          udp = optional(
            object({
              port_max        = optional(number)
              port_min        = optional(number)
              source_port_max = optional(number)
              source_port_min = optional(number)
            })
          )
          icmp = optional(
            object({
              type = optional(number)
              code = optional(number)
            })
          )
        })
      )
    })
  )

  default = [
    {
      name                = "vpc-acl"
      network_connections = ["bastion"]
      rules = [
        {
          name        = "allow-all-inbound"
          action      = "allow"
          direction   = "inbound"
          destination = "0.0.0.0/0"
          source      = "0.0.0.0/0"
        },
        {
          name        = "allow-all-outbound"
          action      = "allow"
          direction   = "outbound"
          destination = "0.0.0.0/0"
          source      = "0.0.0.0/0"
        }
      ]
    },
    {
      name                = "bastion-acl"
      network_connections = ["vpc"]
      rules = [
        {
          name        = "allow-all-inbound"
          action      = "allow"
          direction   = "inbound"
          destination = "0.0.0.0/0"
          source      = "0.0.0.0/0"
        },
        {
          name        = "allow-all-outbound"
          action      = "allow"
          direction   = "outbound"
          destination = "0.0.0.0/0"
          source      = "0.0.0.0/0"
        }
      ]
    }
  ]

  validation {
    error_message = "ACL rules can only have one of `icmp`, `udp`, or `tcp`."
    condition = length(distinct(
      # Get flat list of results
      flatten([
        # Check through rules
        for rule in flatten([var.network_acls.*.rules]) :
        # Return true if there is more than one of `icmp`, `udp`, or `tcp`
        true if length(
          [
            for type in ["tcp", "udp", "icmp"] :
            true if rule[type] != null
          ]
        ) > 1
      ])
    )) == 0 # Checks for length. If all fields all correct, array will be empty
  }

  validation {
    error_message = "ACL rule actions can only be `allow` or `deny`."
    condition = length(distinct(
      flatten([
        # Check through rules
        for rule in flatten([var.network_acls.*.rules]) :
        # Return false action is not valid
        false if !contains(["allow", "deny"], rule.action)
      ])
    )) == 0
  }

  validation {
    error_message = "ACL rule direction can only be `inbound` or `outbound`."
    condition = length(distinct(
      flatten([
        # Check through rules
        for rule in flatten([var.network_acls.*.rules]) :
        # Return false if direction is not valid
        false if !contains(["inbound", "outbound"], rule.direction)
      ])
    )) == 0
  }

  validation {
    error_message = "ACL rule names must match the regex pattern ^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$."
    condition = length(distinct(
      flatten([
        # Check through rules
        for rule in flatten([var.network_acls.*.rules]) :
        # Return false if direction is not valid
        false if !can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", rule.name))
      ])
    )) == 0
  }

}

variable "security_group_rules" {
  description = "A list of security group rules to be added to the default vpc security group"
  type = list(
    object({
      name      = string
      direction = string
      remote    = string
      tcp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      udp = optional(
        object({
          port_max = optional(number)
          port_min = optional(number)
        })
      )
      icmp = optional(
        object({
          type = optional(number)
          code = optional(number)
        })
      )
    })
  )

  default = [
    {
      name      = "allow-inbound-ping"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      icmp = {
        type = 8
      }
    },
    {
      name      = "allow-inbound-ssh"
      direction = "inbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 22
        port_max = 22
      }
    },
  ]

  validation {
    error_message = "Security group rules can only have one of `icmp`, `udp`, or `tcp`."
    condition = length(distinct(
      # Get flat list of results
      flatten([
        # Check through rules
        for rule in var.security_group_rules :
        # Return true if there is more than one of `icmp`, `udp`, or `tcp`
        true if length(
          [
            for type in ["tcp", "udp", "icmp"] :
            true if rule[type] != null
          ]
        ) > 1
      ])
    )) == 0 # Checks for length. If all fields all correct, array will be empty
  }

  validation {
    error_message = "Security group rule direction can only be `inbound` or `outbound`."
    condition = length(distinct(
      flatten([
        # Check through rules
        for rule in var.security_group_rules :
        # Return false if direction is not valid
        false if !contains(["inbound", "outbound"], rule.direction)
      ])
    )) == 0
  }

  validation {
    error_message = "Security group rule names must match the regex pattern ^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$."
    condition = length(distinct(
      flatten([
        # Check through rules
        for rule in var.security_group_rules :
        # Return false if direction is not valid
        false if !can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", rule.name))
      ])
    )) == 0
  }
}


##############################################################################
