# Opella DevOps Challenge with Azure

## Overview

This repository contains Terraform code to deploy resources in Azure as part of the Opella DevOps Technical Challenge. It focuses on networking, security, route tables, and environment management.

## Modules

### VNET Module
- **Purpose**: Creates a Virtual Network (VNet) with subnets, network security groups, and route tables.
- **Inputs**:
  - `resource_group_name`: Name of the resource group.
  - `location`: Azure region.
  - `vnet_name`: Name of the Virtual Network.
  - `address_space`: Address space for the VNet.
  - `subnets`: Configuration of subnets (public, private).
  - `security_groups`: Security group definitions.
  - `route_tables`: Route table definitions.
  - `vnet_tags`: Tags for the VNet.

### Container Module
- **Purpose**: Creates a container instance in Azure for running Docker containers.
- **Inputs**:
  - `container_name`: Name of the container instance.
  - `image`: Docker image to use for the container.
  - `cpu_cores`: Number of CPU cores for the container.
  - `memory_gb`: Memory in GB for the container.

## How it works

1. **VNET**: The VNet is created using the address space provided. Subnets are configured with respective security groups and route tables.
2. **Security Groups**: These are applied to the subnets with the specified rules (like allowing HTTP/HTTPS traffic).
3. **Route Tables**: Configures default routes and custom routes for the subnets.
4. **Containers**: A container is deployed based on the Docker image specified, with CPU and memory configurations provided.

## State Management

- The Terraform state is stored in an Azure Storage Account bucket, ensuring that the state is safely managed and shared across environments.

## Deploying to Different Environments

- An example configuration for the `DEV` environment is provided in this repository. For other environments (e.g., `prod`, `staging`), the process is the same:
  1. Initialize the environment by running `terraform init`.
  2. Copy the Terraform files into the respective environment folder.
  3. Update the values in the `terraform.tfvars` for each specific environment (such as resource names, regions, etc.).

## How to manual deploy

1. Clone the repository.
2. Adjust the `terraform.tfvars` for the `DEV` environment or create a new one for other environments.
3. Run the following commands to deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply
