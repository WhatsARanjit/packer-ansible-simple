# Owner
variable "owner" {
  type = string
}

# Auth
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}

# Platform specific
variable "resource_group_name" {
  description = "Resource group to create the image in"
}

# Image
source "azure-arm" "ubuntu-image" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  # Image name
  managed_image_name                = "${var.owner}_{{timestamp}}"
  managed_image_resource_group_name = "${var.resource_group_name}"

  # Tags
  azure_tags = {
    dept = "${var.owner}_demo"
  }

  # Image params
  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "UbuntuServer"
  image_sku       = "14.04.4-LTS"
  location        = "East US 2"
  vm_size         = "Standard_A2"
}

# Ansible
build {
  sources = [
    "source.azure-arm.ubuntu-image"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }
}
