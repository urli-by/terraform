#------------------------------------------------------------------
#  Terraform - From Zero to Certified Professional
#
# Provision Highly Availabe Web Cluster in any Region Default VPC
# Create:
#    - Security Group for Web Server and ELB
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
# Update to Web Servers will be via Green/Blue Deployment Strategy
# Developed by Urli
#------------------------------------------------------------------

provider "aws" {
  region = "eu-west-1"
}

resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

data "aws_availability_zones" "working" {}
data "aws_ami" "latest_amazonlinux" {
    owners = ["137112412989"]
    most_recent = true
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
    }
}

//Security Group
resource "aws_security_group" "web" {
  name = "Web Security Group"
  vpc_id = aws_default_vpc.default.id # This need to be added since AWS Provider v4.29+ to set VPC id
  dynamic "ingress" {
    for_each = ["80", "443"]
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
    name = "Web Security Group"
    owner = "urli_by"
  }
}

// Launch Configuration
resource "aws_launch_configuration" "web" {
  name_prefix = "WebServer-HighlyAvailable-LC-"
  image_id = data.aws_ami.latest_amazonlinux.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web.id]
  user_data = file("user-data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

// Autoscaling Group
resource "aws_autoscaling_group" "web" {
  name = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size = 3
  max_size = 3
  min_elb_capacity = 3
  health_check_type = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
        Name = "WebServer in ASG"
        Owner = "urli_by"
        TAGKEY = "TAGVALUE"
    }
    content {
        key = tag.key
        value = tag.value
        propagate_at_launch = true
    }
  }    
  lifecycle {
    create_before_destroy = true
  }
  
}

// ELB
resource "aws_elb" "web" {
  name = "WebServer-HighlyAvailable-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups = [aws_security_group.web.id]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold =2
    unhealthy_threshold = 2
    timeout =3
    target = "HTTP:80/"
    interval = 10
  }
  tags = {
    name = "WebServer-HighlyAvailable-ELB"
    owner = "urli_by"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}