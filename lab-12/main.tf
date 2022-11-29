#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
    region = "eu-west-1"
}


data "aws_ami" "latest_ubuntu22" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
}

data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

data "aws_ami" "latest_windowsserver2022" {
    owners = ["801119661308"]
    most_recent = true
    filter {
        name = "name"
        values = ["Windows_Server-2022-English-Full-Base-*"]
    }
}

output "ubuntu_ami" {
  value = data.aws_ami.latest_ubuntu22.id
}

output "amazon_ami" {
    value = data.aws_ami.latest_amazonlinux.id
}

output "windows_server" {
  value = data.aws_ami.latest_windowsserver2022.id
}