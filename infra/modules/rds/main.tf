resource "aws_db_instance" "ArchFactsDB" {
  identifier           = "archfacts-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = var.db_user
  password             = var.db_password
  db_name              = var.db_name
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false

  db_subnet_group_name   = var.rds_subnet_group_name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az = false

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "ArchFacts-RDS"
  }
}
