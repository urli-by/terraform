#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_eip" "web" {
  vpc = true
  instance = aws_instance.web.id
  tags = {
    learn = "terraform"
    lab = "6"
  }
  
}

resource "aws_instance" "web" {
  ami = "ami-01cae1550c0adea9c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = file("user-data.sh")
  user_data_replace_on_change = true  
  tags = {
    learn = "terraform"
    lab = "6"
  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "web" {
    name = "Webserver_with_EIP_sg"
    description = "static IP"
    vpc_id = aws_default_vpc.default.id
    
    dynamic "ingress" {
        for_each = ["80", "443"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    ingress {
    description = "allow port SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "allow all ports"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
      learn = "terraform"
      name = "webserver SG"
    }
}