
variable "public_key_location" {
  description = "Path to public SSH key file"
  type        = string
}


variable "db_password" {
  description = "The password for the WordPress database"
  type        = string
  sensitive   = true
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "env_prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_a_cidr_block" {
  type = string
}

variable "public_subnet_b_cidr_block" {
  type = string
}

variable "wordpress_a_privatesubnet_cidr_block" {
  type = string
}

variable "wordpress_b_privatesubnet_cidr_block" {
  type = string
}

variable "rds_a_privatesubnet_cidr_block" {
  type = string
}

variable "rds_b_privatesubnet_cidr_block" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "domain_name" {}

variable "route53_zone_id" {}

variable "allocated_storage" {}

variable "storage_type" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "target_group_name" {}

variable "target_group_port" {}

variable "target_group_protocol" {}

variable "target_type" {}

variable "internal" {
  type = bool
}

variable "ssl_policy" { type = string }


variable "ami_owners" { type = list(string) }

variable "ami_name_pattern" { type = string }

variable "ami_virtualization_type" { type = string }

variable "ssh_key_name" { type = string }


