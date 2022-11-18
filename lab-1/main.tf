provider "aws" {
  
}

resource "aws_instance" "My_first_inst" {
    ami             = "ami-096800910c1b781ba"
    instance_type   = "t2.micro"

    tags = {
        learn       = "terraform"
        lab         = "1"
    } 
}

resource "aws_instance" "My_second_inst" {
    ami             = "ami-01cae1550c0adea9c"
    instance_type   = "t2.micro"
    key_name        = "urli_terraform_key_18_11_2022"
    tags = {
        learn       = "terraform"
        lab         = "1"
    }
  
}