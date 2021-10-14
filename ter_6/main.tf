provider "aws" {
        region = "eu-central-1"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = local.web_instance_type_map[terraform.workspace]
}

resource "aws_instance" "web2" {
  for_each = local.instances
  ami = each.value
  instance_type = each.key
  create_before_destroy = true
}

locals {
  web_instance_count_map = {
    stage = 0
    prod = 1
  }
}

locals {
  instances = {
    "t3.micro" = data.aws_ami.amazon_linux.id
    "t3.large" = data.aws_ami.amazon_linux.id
  }
}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod = "t2.micro"
    default = "t2.micro"
  }
}