#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
    region = "eu-west-1"
}

data "aws_region" "current" {}
data "aws_vpcs" "vpcs" {}
data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "PROD"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Public subnet"
    Info = "AZ: ${data.aws_availability_zones.working.names[0]} in Region: ${data.aws_region.current.description}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private subnet"
    Info = "AZ: ${data.aws_availability_zones.working.names[1]} in Region: ${data.aws_region.current.description}"
  }
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "avaiability_zones" {
  value = data.aws_availability_zones.working.names
}

output "all_vpc_ids" {
  value = data.aws_vpcs.vpcs.ids
}