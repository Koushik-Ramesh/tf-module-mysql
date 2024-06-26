# Creates RDS Instance
resource "aws_db_instance" "mysql" {
  allocated_storage       = var.MYSQL_STORAGE
  identifier              = "roboshop-${var.ENV}-mysql"
  engine                  = "mysql"
  engine_version          = var.MYSQL_ENGINE_VERSION
  instance_class          = var.MYSQL_INSTANCE_TYPE
  username                = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["MYSQL_USERNAME"]
  password                = jsondecode(data.aws_secretsmanager_secret_version.secret_version.secret_string)["MYSQL_PASSWORD"]
  parameter_group_name    = aws_db_parameter_group.mysql.name
  db_subnet_group_name    = aws_db_subnet_group.mysql.name
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.allows_mysql.id]
}

resource "aws_db_subnet_group" "mysql" {
  name       = "roboshop-${var.ENV}-mysql-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS

  tags = {
    Name = "roboshop-${var.ENV}-mysql-subnet-group"
  }
}

resource "aws_db_parameter_group" "mysql" {
  name   = "roboshop-${var.ENV}-mysql-parameter-group"
  family = "mysql5.7"
}

