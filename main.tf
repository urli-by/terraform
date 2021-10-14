provider "aws" {
    region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  dict_of_instance_types = {
    stage = "t2.micro"
    prod = "t2.small"
  }
}

locals {
  dict_of_instance_count = {
    stage = 1
    prod = 2
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "instance_ip_addr" "current" {}

data "private_ip" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}