// Craeado con el az cli, pusheada la imagen de nginx y la etiqueta latest para luego ser importado en el state de tf
resource "azurerm_container_registry" "nginx" {
  name                = "oppelanginxaf"
  location            = module.shared.european_region
  resource_group_name = module.shared.resource_group_name
  sku                 = "Basic"
  admin_enabled       = true
  tags = {
    environment = var.environment
    project     = "nginx-container"
  }
}

module "nginx_container" {
  source              = "../../modules/CONTAINER"
  location            = module.shared.european_region
  resource_group_name = module.shared.resource_group_name
  container_name      = "nginx-container-group"
  server              = azurerm_container_registry.nginx.login_server
  admin_username      = azurerm_container_registry.nginx.admin_username
  admin_password      = azurerm_container_registry.nginx.admin_password
  expose_to_public    = true
  dns_name_label      = "nginx-${var.environment}"
  tags = {
    environment = var.environment
    project     = "nginx-container"
  }

  containers = [
    {
      name     = "nginx-container"
      image    = "${azurerm_container_registry.nginx.login_server}/nginx:latest"
      cpu      = 1
      memory   = 1.5
      port     = 80
      protocol = "TCP"
    }
  ]

  depends_on = [azurerm_container_registry.nginx]
}
