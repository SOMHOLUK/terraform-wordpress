
resource "aws_db_subnet_group" "database-subnet-group" {
  name       = "${var.env_prefix}-database-subnets"
  subnet_ids = var.subnet_ids 

  tags = {
    Name =  "${var.env_prefix}-database-subnets"
  }
}


resource "aws_db_instance" "wordpress-database" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  skip_final_snapshot    = true
  multi_az               = true
  vpc_security_group_ids = var.vpc_security_group_ids 

}













 



