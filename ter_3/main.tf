provider "aws" {
  region = "eu-central-1"

}

resource "aws_security_group" "dynamic" {
  name        = "dynamic security group"
  description = "My dynamic security group"

dynamic "ingress" {
  for_each = ["80", "443", "8080", "553"]
  content {
    description      = "dynamic"
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["10.10.0.0/16"]
  }
  egress  {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "Dynamic"
  }
}