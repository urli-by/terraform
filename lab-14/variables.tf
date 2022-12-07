variable "aws_region" {
  description = "Region where you want to provision this EC2 WebServer"
  type = string
  default = "eu-west-1"
}

variable "ingress_port_list" {
  description = "List of ports to open for your WebServer"
  type = list(any)
  default = ["80", "443", "22"]
}

variable "instance_size" {
  description = "EC2 instance Size to provision"
  type = string
  default = "t2.small"
}

variable "tags" {
  description = "Tags to Apply to Resources"
  type = map(any)
  default = {
    Owner = "Aliuaksandr Molchan"
    Environment = "Prod"
    Project = "Phoenix"
  }
}

variable "key_pair" {
    description = "SSH key pair name to ingest into EC2"
    type = string
    default = "urli-terraform-ssh"
    sensitive = true
}
/*
variable "password" {
    description = "Please enter Password lenght of 10 characters!"
    type = string
    sensitive = true
    validation {
        condition = length(var.password) == 10
        error_message = "Your password must be 10 characted exactly!!!"
    }
}
*/