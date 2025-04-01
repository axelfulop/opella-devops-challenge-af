resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  dns_servers             = try(var.dns_servers, null)
  bgp_community           = try(var.bgp_community, null)
  edge_zone               = try(var.edge_zone, null)
  flow_timeout_in_minutes = try(var.flow_timeout_in_minutes, null)


  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection != null && var.ddos_protection_plan_id != null ? [1] : []
    content {
      enable = var.enable_ddos_protection
      id     = var.ddos_protection_plan_id
    }
  }

  dynamic "encryption" {
    for_each = var.encryption_enforcement != null ? [1] : []
    content {
      enforcement = var.encryption_enforcement
    }
  }


  dynamic "subnet" {
    for_each = var.subnets
    content {
      name                            = subnet.value.name
      address_prefixes                = subnet.value.address_prefixes
      security_group                  = try(azurerm_network_security_group.sg[subnet.value.security_group].id, null)
      default_outbound_access_enabled = try(subnet.value.default_outbound_access_enabled, null)
      dynamic "delegation" {
        for_each = try(subnet.value.delegation, [])
        content {
          name = delegation.value.name
          service_delegation {
            name    = delegation.value.service_delegation.name
            actions = delegation.value.service_delegation.actions
          }
        }
      }
      private_endpoint_network_policies             = try(subnet.value.private_endpoint_network_policies, null)
      private_link_service_network_policies_enabled = try(subnet.value.private_link_service_network_policies_enabled, null)
      route_table_id                                = try(azurerm_route_table.route_table[subnet.value.route_table_id].id,null)
      service_endpoint_policy_ids                   = try(subnet.value.service_endpoint_policy_ids, null)
      service_endpoints                             = try(subnet.value.service_endpoints, null)
    }

  }

  tags = var.vnet_tags
}

resource "azurerm_network_security_group" "sg" {
  for_each            = var.security_groups
  name                = each.value.sg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = try(each.value.security_rules, [])
    content {
      name                                       = security_rule.value.name
      description                                = try(security_rule.value.description, "")
      priority                                   = security_rule.value.priority
      direction                                  = security_rule.value.direction
      access                                     = security_rule.value.access
      protocol                                   = security_rule.value.protocol
      source_port_range                          = try(security_rule.value.source_port_range, null)
      source_port_ranges                         = try(security_rule.value.source_port_ranges, null)
      destination_port_range                     = try(security_rule.value.destination_port_range, null)
      destination_port_ranges                    = try(security_rule.value.destination_port_ranges, null)
      source_address_prefix                      = try(security_rule.value.source_address_prefix, null)
      source_address_prefixes                    = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefix                 = try(security_rule.value.destination_address_prefix, null)
      destination_address_prefixes               = try(security_rule.value.destination_address_prefixes, null)
      source_application_security_group_ids      = try(security_rule.value.source_application_security_group_ids, null)
      destination_application_security_group_ids = try(security_rule.value.destination_application_security_group_ids, null)
    }
  }

  tags = try(each.value.sg_tags, {})
}

resource "azurerm_route_table" "route_table" {
  for_each                      = var.route_tables
  name                          = each.value.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = try(each.value.bgp_route_propagation_enabled, true)

  dynamic "route" {
    for_each = try(each.value.routes, [])
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }

  tags = try(each.value.tags, {})
}
