resource "azurerm_container_group" "container" {
  name                = var.container_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  
  dns_name_label = var.dns_name_label
  os_type = var.os_type

image_registry_credential {
    server   = var.server
    username = var.admin_username
    password = var.admin_password
  }


  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory

      ports {
        port     = container.value.port
        protocol = container.value.protocol
      }
    }
  }
ip_address_type = var.expose_to_public ? "Public" : "Private"
}

resource "azurerm_public_ip" "nginx_public_ip" {
  count               = var.expose_to_public ? 1 : 0
  name                = "nginx-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                  = "Basic"

  tags = var.tags
}