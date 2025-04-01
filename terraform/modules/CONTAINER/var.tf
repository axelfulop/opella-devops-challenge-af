variable "container_name" {
  description = "Name of the container group"
  type        = string
}

variable "os_type" {
  description = "The OS type of the container group (Linux or Windows)"
  type        = string
  default     = "Linux"
  
}

variable "location" {
  description = "The Azure location where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "server" {
    description = "The server name for the container registry"
    type        = string
    }

variable "admin_username" {
    description = "The admin username for the container registry"
    type        = string
    sensitive = true
    }

variable "admin_password" {
    description = "The admin password for the container registry"
    type        = string
    sensitive = true
    }

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "expose_to_public" {
  description = "Flag to determine if the container should be accessible from the outside (public IP)"
  type        = bool
  default     = true
}

variable "containers" {
  description = "A list of container configurations"
  type = list(object({
    name     = string
    image    = string
    cpu      = number
    memory   = number
    port     = number
    protocol = string
  }))
  default = [
    {
      name     = "nginx-container"
      image    = "nginx:latest"
      cpu      = 1
      memory   = 1.5
      port     = 80
      protocol = "TCP"
    }
  ]
}
