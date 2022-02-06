# Owner
variable "owner" {
  type = string
}

# Auth
## ENV variables

# Platform specific
variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

# Image
source "hyperv-iso" "ubuntu-image" {
  iso_url          = "http://releases.ubuntu.com/12.04/ubuntu-12.04.5-server-amd64.iso"
  iso_checksum     = "md5:769474248a3897f4865817446f9a4a53"
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"

  # Image name
  vm_name = "${var.owner}_{{timestamp}}"
}

# Ansible
build {
  sources = [
    "source.hyperv-iso.ubuntu-image"
  ]
}
