

variable "env_prefix" { type = string }

variable "ami_owners" { type = list(string) }

variable "ami_name_pattern" { type = string }

variable "ami_virtualization_type" { type = string }

variable "ssh_key_name" { type = string }

variable "public_key_location" { type = string }

variable "instance_type" { type = string }

variable "aws_region" { type = string }

variable "db_name" { type = string }

variable "db_username" { type = string }

variable "db_password" { type = string }

variable "public_subnet_a_id" { type = string }

variable "wordpress_a_private_subnet_id" { type = string }

variable "wordpress_b_private_subnet_id" { type = string }


variable "bastion_sg_id" { type = string }

variable "wordpress_sg_id" { type = string }

variable "db_endpoint" {

  type        = string
}

