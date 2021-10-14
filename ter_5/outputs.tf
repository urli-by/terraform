output "web_server_instance_id" {
  value = aws_instance.web_server.id
}

output "web_server_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_user_id" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_current_region" {
  value = aws_instance.web_server.availability_zone
}

output "web_server_private_ip" {
  value = aws_eip.my_static_ip.private_ip
}

output "web_server_subnet_id" {
  value = aws_instance.web_server.subnet_id
}
