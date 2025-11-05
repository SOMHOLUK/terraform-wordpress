  variable "target_group_name" { type = string}

  variable "target_group_port" {
    type = number
  }

  variable "target_group_protocol" { type = string}

  variable "target_group_vpc_id" { type = string}

  variable "env_prefix" {   type = string}

variable "security_group_ids" {  type = list(string)}

variable "subnet_ids" { type = list(string)}

variable "target_type" {}

variable "internal" {
  type        = bool
  default     = false
}

variable "ssl_policy" { type = string}

 variable "certificate_arn" {}

variable "wordpress_instance_id_a" { type = string}

variable "wordpress_instance_id_b" { type = string}
