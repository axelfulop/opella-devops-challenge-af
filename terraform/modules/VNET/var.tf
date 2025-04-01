variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
}

variable "resource_group_tags" {
  description = "A map of tags to apply to the resource group."
  type        = map(string)
  default     = {}
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers for the virtual network."
  type        = list(string)
  default     = []
}

variable "private_endpoint_vnet_policies" {
  description = "Enable or disable network policies for the private endpoint."
  type        = bool
  default     = null
}

variable "bgp_community" {
  description = "The BGP community attribute for the virtual network."
  type        = string
  default     = null
}

variable "edge_zone" {
  description = "The Edge Zone within the region for the virtual network."
  type        = string
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "The flow timeout in minutes for the virtual network."
  type        = number
  default     = null
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection for the virtual network."
  type        = bool
  default     = null
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan."
  type        = string
  default     = null
}

variable "encryption_enforcement" {
  description = "Enforce encryption for the virtual network."
  type        = string
  default     = null
}

variable "subnets" {
  description = "A map of subnets to be created in the virtual network."
  type = map(object({
    name                            = string
    address_prefixes                = list(string)
    security_group                  = optional(string)
    default_outbound_access_enabled = optional(bool, null)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })), [])
    private_endpoint_network_policies             = optional(string, null)
    private_link_service_network_policies_enabled = optional(bool, null)
    route_table_id                                = optional(string, null)
    service_endpoint_policy_ids                   = optional(list(string), [])
    service_endpoints                             = optional(list(string), [])
  }))
  default = {}
}

variable "vnet_tags" {
  description = "A map of tags to apply to the virtual network."
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  type = map(object({
    sg_name              = string
    subnet_name          = string
    virtual_network_name = string
    address_prefix       = string
    security_rules = optional(list(object({
      name                                       = string
      description                                = optional(string, "")
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
      source_port_range                          = optional(string)
      source_port_ranges                         = list(string)
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(list(string))
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    })), [])
    sg_tags = optional(map(string), {})
  }))
}

variable "route_tables" {
  type = map(object({
    name                     = string
    bgp_route_propagation_enabled = optional(bool, true)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
    tags = optional(map(string), {})
  }))
}
