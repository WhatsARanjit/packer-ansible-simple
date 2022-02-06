# HCP Packer information
variable "version" {
  type    = string
  default = "none"
}

build {
  name = "hcp_packer"

  hcp_packer_registry {
    bucket_name   = "aws_nginx"
    bucket_labels = {
      role = "nginx"
    }
    build_labels  = {
      version = var.version
    }
  }

  sources = [
    "source.${source}.ubuntu-image"
  ]
}
