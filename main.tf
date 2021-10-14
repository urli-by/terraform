provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip" "my_static_ip" {
  instance = module.ec2_module.id
}
module "ec2_module" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name          = "done-with-ec2_module"
  ami           = "ami-0453cb7b5f2b7fca2"
  instance_type = "t2.micro"
}
#resource "aws_instance" "web_server" {
#  ami               = "ami-0453cb7b5f2b7fca2" #Amazon
#  instance_type     = "t2.micro"
#  vpc_security_group_ids = [aws_security_group.webserver.id]
#  user_data = templatefile("user.sh", {
#    f_name = "urli"
#    l_name = "by"
#    names = ["vasya", "kolya", "masha", "katya"]
#  })
#
#  tags = {
#    Name = "webServer"
#    Owner = "urli_by"
#  }

#  lifecycle {
#    create_before_destroy = true
#  }
#}

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

