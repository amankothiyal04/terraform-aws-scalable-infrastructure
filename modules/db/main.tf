# Subnet group for RDS (tells AWS where to put the DB)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-private-subnets-${terraform.workspace}"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.tags, { Name = "rds-subnet-group" })
}

# RDS instance
resource "aws_db_instance" "mysql" {
  identifier              = "terraform-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [var.sg_id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  multi_az                = false

  tags = merge(var.tags, { Name = "terraform-rds" })
}
