##############################################################################
# Network ACL
##############################################################################

locals {

  # List of network connections by ACL name
  network_connections = {
    for network_acl in var.network_acls :
    network_acl.name => network_acl.network_connections if network_acl.network_connections != null
  }

  # Create Connections Map where each tier contains a list of other tiers each tier will connect to
  connection_map = {
    for tier in var.subnet_tiers :
    tier.acl_name => local.network_connections[tier.acl_name]
  }

  # Create a list of inbound and outbound rules by tier
  /*tier_subnet_rules = {
            for tier in var.subnet_tiers:
            tier.name => flatten([
                  # For each subnet in a list of all subnets in that tier
                  for subnet in flatten([ for zone in keys(tier.subnets): tier.subnets[zone] ]):
                  [
                        { 
                              name        = "allow-inbound-${var.prefix}-${tier.name}-${subnet.name}"
                              action      = "allow"
                              direction   = "inbound"
                              destination = "0.0.0.0/0"
                              source      = subnet.cidr
                              tcp         = null
                              udp         = null
                              icmp        = null
                        },
                        {
                              name        = "allow-outbound-${var.prefix}-${tier.name}-${subnet.name}"
                              action      = "allow"
                              direction   = "outbound"
                              destination = subnet.cidr
                              source      = "0.0.0.0/0"
                              tcp         = null
                              udp         = null
                              icmp        = null
                        }
                  ]
            ])
      }*/

  # ACL Objects                                                                                    
  acl_object = {
    for network_acl in var.network_acls :
    network_acl.name => {
      rules = network_acl.rules
    }
  }

}

resource "ibm_is_network_acl" "multitier_acl" {
  for_each       = local.acl_object
  name           = "${var.prefix}-${each.key}"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.resource_group.id

  # Create ACL rules
  dynamic "rules" {
    for_each = each.value.rules
    content {
      name        = rules.value.name
      action      = rules.value.action
      source      = rules.value.source
      destination = rules.value.destination
      direction   = rules.value.direction

      dynamic "tcp" {
        for_each = rules.value.tcp == null ? [] : [rules.value]
        content {
          port_min        = rules.value.tcp.port_min
          port_max        = rules.value.tcp.port_max
          source_port_min = rules.value.tcp.source_port_min
          source_port_max = rules.value.tcp.source_port_min
        }
      }

      dynamic "udp" {
        for_each = rules.value.udp == null ? [] : [rules.value]
        content {
          port_min        = rules.value.udp.port_min
          port_max        = rules.value.udp.port_max
          source_port_min = rules.value.udp.source_port_min
          source_port_max = rules.value.udp.source_port_min
        }
      }

      dynamic "icmp" {
        for_each = rules.value.icmp == null ? [] : [rules.value]
        content {
          type = rules.value.icmp.type
          code = rules.value.icmp.code
        }
      }
    }
  }
}

##############################################################################