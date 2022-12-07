#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "myserver" {
  ami = "ami-01cae1550c0adea9c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name = "urli-terraform-ssh"
  tags = {
    name = "MY ec2 with remote-exec"
    owner = "Aliaksandr Molchan"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ec2-user/terraform",
      "cd /home/ec2-user/terraform",
      "touch hello.txt",
      "echo 'Terraform was here..' > terraform.txt"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
      private_key = file("../urli-terraform-ssh.pem")
    }
  }
}

resource "aws_security_group" "web" {
  name = "My security group"
  vpc_id = aws_default_vpc.default.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "SG for webserver"
    owner = "Aliaksandr Molchan"
  }
}