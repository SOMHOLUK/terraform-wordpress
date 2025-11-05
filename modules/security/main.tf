
resource "aws_security_group" "alb-security-group" {
  name        = "${var.env_prefix}-alb-sg"
  description = "Security group for WordPress ALB. Allows HTTP and HTTPS from anywhere, into application load balancer (alb)"
  vpc_id      = var.vpc_id

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-ALB-SecurityGroup"
  }
}




resource "aws_security_group" "bastion-host-security-group" {
  name        = "${var.env_prefix}bastion-host-sg"
  description = "Allows SSH traffic from trusted IP to bastion host"
  vpc_id      = var.vpc_id

  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-Bastion-Host-Security-Group"
  }

}





resource "aws_security_group" "wordpress-app-security-group" {
  name        = "${var.env_prefix}-wordpress-app-sg"
  description = "Allows HTTP traffic from Application Load Balancer (ALB) and SSH traffic from Bastion-host"
  vpc_id      = var.vpc_id


  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-security-group.id]
  }


  
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-host-security-group.id]
  } 


  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-Wordpress-App-Security-Group"
  }

}






resource "aws_security_group" "rds-database-security-group" {
  name        = "${var.env_prefix}-rds-database-sg"
  description = "Allows database traffic from Wordpress App"
  vpc_id      = var.vpc_id

  

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress-app-security-group.id]
  }

  


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-RDS-Database-Security-Group"
  }
}

