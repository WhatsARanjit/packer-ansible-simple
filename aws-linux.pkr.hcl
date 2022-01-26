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
source "amazon-ebs" "ubuntu-image" {
  instance_type  = var.aws_instance_type

  # Image name
  ami_name       = "${var.owner}_{{timestamp}}"

  # Tags
  tags = {
    Name = "${var.owner}_demo"
  }

  # Image params
  source_ami_filter {
    filters               = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  communicator = "ssh"
  ssh_username = "ubuntu"
}

# Ansible
build {
  sources = [
    "source.amazon-ebs.ubuntu-image"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }
}
