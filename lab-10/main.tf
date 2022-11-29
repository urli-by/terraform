#----------------------------
# MY Terraform
#----------------------------
# Made by me
#----------------------------

provider "aws" {
    region = "eu-west-1"
  
}

resource "aws_db_instance" "prod" {
  identifier = "prod-mysql-rds"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  apply_immediately = true
  username = "administrator"
  password = data.aws_secretsmanager_secret_version.rds_password1.secret_string
}

//Generate Password
resource "random_password" "main" {
  length = 20
  special = true
  override_special = "#!()_"
}

//Store Password
resource "aws_secretsmanager_secret" "rds_password1" {
  name = "/prod/rds/password1"
  description = "Password_for_rds"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds_password1" {
  secret_id = aws_secretsmanager_secret.rds_password1.id
  secret_string = random_password.main.result
}

//Store All Rds Parameters
resource "aws_secretsmanager_secret" "rds1" {
  name = "/prod/rds/all1"
  description = "All Detail of RDS"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rds1" {
  secret_id = aws_secretsmanager_secret.rds1.id
  secret_string = jsonencode({
    rds_endpoint = aws_db_instance.prod.endpoint
    rds_username = aws_db_instance.prod.username
    rds_password = random_password.main.result
  })
}

// Retrieve Password
data "aws_secretsmanager_secret_version" "rds_password1" {
  secret_id = aws_secretsmanager_secret.rds_password1.id
  depends_on = [
    aws_secretsmanager_secret.rds_password1
  ]
}

// Retreive ALL
data "aws_secretsmanager_secret_version" "rds" {
  secret_id  = aws_secretsmanager_secret.rds1.id
  depends_on = [aws_secretsmanager_secret_version.rds1]
}

#---------------
output "rds_endpoint" {
  value = jsondecode(aws_secretsmanager_secret_version.rds1.secret_string)["rds_endpoint"]
  sensitive = true
}

output "rds_username" {
  value = jsondecode(aws_secretsmanager_secret_version.rds1.secret_string)["rds_username"]
  sensitive = true
}

output "rds_password" {
  value = jsondecode(aws_secretsmanager_secret_version.rds1.secret_string)["rds_password"]
  sensitive = true
}