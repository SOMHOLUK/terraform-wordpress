  variable "db_name" {}

  variable "db_username" {
      type        = string
  sensitive   = true
  }

  variable "db_password" {
      type        = string
  sensitive   = true 
  }

  variable "env_prefix" {}

  variable "allocated_storage" { type = number}

variable "storage_type" { type = string}

variable "engine" { type = string}

variable "engine_version" { type = string}

variable "instance_class" { type = string}

variable "subnet_ids" {} 

variable "vpc_security_group_ids" {} 

  variable "aws_region" {}
  




