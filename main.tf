terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region_name
}

resource "aws_instance" "app_server" {
  ami                     = var.ami_id
  instance_type           = var.instance_type_name
  vpc_security_group_ids  = var.vpc_security
  key_name                = var.key_name_id
  subnet_id               = var.subnet_id

  tags = {
    Name = var.tag_name
    APP  = var.tag_app
  }
}

