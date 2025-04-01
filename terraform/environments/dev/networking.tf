module "vnet" {
  source              = "../../modules/VNET"
  resource_group_name = module.shared.resource_group_name
  location            = module.shared.european_region
  vnet_name           = local.vnet_name
  address_space       = ["10.0.0.0/22"]

  subnets = {
    public_subnet = {
      name              = "public-subnet"
      security_group    = "public-sg"
      address_prefixes  = ["10.0.0.0/24"]
      security_group    = "public-sg"
      route_table_id    = "public-rt"
      service_endpoints = ["Microsoft.Storage"]
    }
    private_subnet = {
      name             = "private-subnet"
      security_group   = "private-sg"
      address_prefixes = ["10.0.1.0/24"]
      security_group   = "private-sg"
      route_table_id   = "private-rt"
    }
  }

  security_groups = {
    public-sg = {
      sg_name              = "public-sg"
      subnet_name          = "public-subnet"
      virtual_network_name = local.vnet_name
      address_prefix       = "10.0.0.0/22"

      security_rules = [
        {
          name                         = "allow-http"
          priority                     = 100
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_address_prefix        = "10.0.0.0/22"
          source_port_ranges           = ["0-65535"]
          destination_port_range       = "80"
          destination_address_prefixes = ["0.0.0.0/0"]
        },
        {
          name                         = "allow-https"
          priority                     = 110
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_address_prefix        = "10.0.0.0/22"
          source_port_ranges           = ["0-65535"]
          destination_port_range       = "443"
          destination_address_prefixes = ["0.0.0.0/0"]
        }
      ]
    }
    private-sg = {
      sg_name              = "private-sg"
      subnet_name          = "private-subnet"
      virtual_network_name = local.vnet_name
      address_prefix       = "10.0.0.0/22"
      security_rules       = []
    }
  }

  route_tables = {
    public-rt = {
      name = "public-rt"
      routes = [
        {
          name           = "internet-access"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
    private-rt = {
      name = "private-rt"
      routes = [
        {
          name           = "default-private-route"
          address_prefix = "10.0.0.0/22"
          next_hop_type  = "VnetLocal"
        }
      ]
    }
  }

  vnet_tags = {
    environment = var.environment
    project     = "networking"
  }
}
