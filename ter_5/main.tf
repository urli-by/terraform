provider "aws" {
  region = "eu-central-1"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > myKey.pem"
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.web_server.id
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_server" {
  ami               = "${data.aws_ami.ubuntu.id}"
  instance_type     = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver.id]
  key_name      = aws_key_pair.kp.key_name
  user_data = templatefile("user.sh", {
    f_name = "urli"
    l_name = "by"
    names = ["vasya", "kolya", "masha", "katya"]
  })

  tags = {
    Name = "webServer"
    Owner = "urli_by"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "webserver" {
  name        = "webserver security group"
  description = "My first security group"


  ingress  {
      description      = "80 from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress  {
      description      = "443 from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ingress  {
      description      = "22 from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "allow_tls"
  }

}

data "aws_caller_identity" "current" {}