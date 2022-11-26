provider "aws" {
    region = "eu-west-1"
  
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "web" {
    ami = "ami-01cae1550c0adea9c"

    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.general.id]
    tags = {
      learn = "terraform"
      lab = "7"
      name = "web"
    }  

    depends_on = [
      aws_instance.db,
      aws_instance.app
    ]
}

resource "aws_instance" "app" {
    ami = "ami-01cae1550c0adea9c"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.general.id]
    tags = {
      learn = "terraform"
      lab = "7"
      name = "app"
    }  

    depends_on = [
      aws_instance.db
    ]
}

resource "aws_instance" "db" {
    ami = "ami-01cae1550c0adea9c"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.general.id]
    tags = {
      learn = "terraform"
      lab = "7"
      name = "db"
    }  
}

resource "aws_security_group" "general" {
    name = "My Security Group"
    vpc_id = aws_default_vpc.default.id

    dynamic "ingress" {
        for_each = ["80","443","22","3389"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

tags = {
    name = "My Security Group"
}
  
}


output "My_web_Server" {
    value = [
        aws_instance.web.id,
        aws_instance.web.public_ip,
        aws_instance.web.private_ip
        
    ]
  
}

output "My_app_Server" {
    value = [
        aws_instance.app.id,
        aws_instance.app.public_ip,
        aws_instance.app.private_ip
        
    ]
  
}

output "My_db_Server" {
    value = [
        aws_instance.db.id,
        aws_instance.db.public_ip,
        aws_instance.db.private_ip
        
    ]
  
}