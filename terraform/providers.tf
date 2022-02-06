terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.22.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "hcp" {}

provider "aws" {}
