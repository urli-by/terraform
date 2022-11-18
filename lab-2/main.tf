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
    user_data = <<EOF
#!/bin/bash
yum update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with Private IP: $MYIP</h2><br>Built by Terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF
    tags = {
        learn = "terraform"
        lab = "2"
    }
}

resource "aws_security_group" "WebServer" {
    name = "Webserver SG"
    description = "allow acces to our webserver"
    vpc_id = aws_default_vpc.default.id

    ingress {
        description = "allow port HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow port HTTPS"
        from_port = 443
        to_port = 443
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
        lab = "2"
    }
}
