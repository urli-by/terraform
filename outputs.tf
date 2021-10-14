output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "region_name" {
  value = data.aws_region.current.name
}

output "current_environment" {
  value = "var.urli_workspace"
}

output "instance_ip_addr" {
  value = aws.ami.
}

output "instance_ip_addr" {
  value       = data.aws_instance.current.private_ip
  description = "The private IP address of the main server instance."
}

output "private_ip" {
  description = "Private IP of instance"
  value       = join("", aws_instance.current.*.private_ip)
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}