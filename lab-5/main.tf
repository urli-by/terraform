#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
    region = "eu-west-1"
  
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_instance" "Simple_httpd" {
    ami = "ami-01cae1550c0adea9c" //Amazon Linux
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.WebServer.id]
    user_data = templatefile("external_script.sh.tpl", {
        f_name = "Aliaksandr"
        l_name = "Molchan"
        names = ["John", "Angel", "David", "Victor", "Frank", "Melissa", "Kitana"]
    })
    tags = {
        learn = "terraform"
        lab = "2"
    }
}

resource "aws_security_group" "WebServer" {
    name = "Webserver SG"
    description = "allow acces to our webserver"
    vpc_id = aws_default_vpc.default.id

    dynamic "ingress" {
        for_each = [80, 8080, 443, 1000, 8443]
        content {
            description = "allow port HTTP"
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
        cidr_blocks = ["10.0.0.0/16"]
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
        lab = "2"
    }
}
