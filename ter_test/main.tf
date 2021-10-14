provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "ubuntu" {
  count = 0
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"

  tags = {
    Name = "Ubuntu Server"
    Owner = "urli"
    Project = "test"
  }

}

resource "aws_instance" "amazon" {
  count = 0
  ami = "ami-0453cb7b5f2b7fca2"
  instance_type = "t2.micro"

  tags = {
    Name = "amazon Server"
    Owner = "urli"
    Project = "test"
  }
}