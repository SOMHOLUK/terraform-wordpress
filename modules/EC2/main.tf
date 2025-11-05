

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = [var.ami_name_pattern]

  }

  filter {
    name   = "virtualization-type"
    values =  [var.ami_virtualization_type]
  }
}



resource "aws_key_pair" "ssh-key" {
  key_name   = var.ssh_key_name
  public_key = file(var.public_key_location)

  lifecycle {
    create_before_destroy = true
  }
}


 
resource "aws_instance" "bastion-host" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_a_id  
  vpc_security_group_ids = [var.bastion_sg_id]     
  availability_zone      = "${var.aws_region}a"
  associate_public_ip_address = true
  key_name               = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-Bastion Host"
  }
}


resource "aws_instance" "wordpress-app-a" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  subnet_id              = var.wordpress_a_private_subnet_id  
  vpc_security_group_ids = [var.wordpress_sg_id]               
  availability_zone      = "${var.aws_region}a"
  key_name               = aws_key_pair.ssh-key.key_name


  user_data = templatefile("${path.module}/wordpress.tpl", {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_endpoint = var.db_endpoint

  })

  user_data_replace_on_change = true
  tags = {
    Name = "${var.env_prefix}-Wordpress-App-A"
  }
}


resource "aws_instance" "wordpress-app-b" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  subnet_id              = var.wordpress_b_private_subnet_id  
  vpc_security_group_ids = [var.wordpress_sg_id]               
  availability_zone      = "${var.aws_region}b"
  key_name               = aws_key_pair.ssh-key.key_name


  user_data = templatefile("${path.module}/wordpress.tpl", {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_endpoint = var.db_endpoint
  })

  user_data_replace_on_change = true
  tags = {
    Name = "${var.env_prefix}-Wordpress-App-B"
  }
}













































