

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block                       = var.vpc_cidr_block
  env_prefix                           = var.env_prefix
  public_subnet_a_cidr_block           = var.public_subnet_a_cidr_block
  public_subnet_b_cidr_block           = var.public_subnet_b_cidr_block
  aws_region                           = var.aws_region
  wordpress_a_privatesubnet_cidr_block = var.wordpress_a_privatesubnet_cidr_block
  wordpress_b_privatesubnet_cidr_block = var.wordpress_b_privatesubnet_cidr_block


  rds_a_privatesubnet_cidr_block = var.rds_a_privatesubnet_cidr_block
  rds_b_privatesubnet_cidr_block = var.rds_b_privatesubnet_cidr_block

}


module "acmroute53" {
  source          = "./modules/acmroute53"
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
  env_prefix      = var.env_prefix



  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id

}


module "rds" {
  source            = "./modules/rds"
  env_prefix        = var.env_prefix
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  aws_region        = var.aws_region


  vpc_security_group_ids = [module.security.rds_sg_id]
  subnet_ids             = [module.vpc.rds_a_private_subnet_id, module.vpc.rds_b_private_subnet_id]

}



module "alb" {
  source = "./modules/alb"

  target_group_name = var.target_group_name



  target_group_protocol = var.target_group_protocol

  env_prefix = var.env_prefix

  target_type = var.target_type
  internal    = var.internal
  ssl_policy  = var.ssl_policy



  target_group_port = var.target_group_port

  certificate_arn    = module.acmroute53.certificate_arn
  security_group_ids = [module.security.alb_sg_id]


  subnet_ids              = [module.vpc.public_subnet_a_id, module.vpc.public_subnet_b_id]
  target_group_vpc_id     = module.vpc.vpc_id
  wordpress_instance_id_a = module.EC2.wordpress_app_a_id
  wordpress_instance_id_b = module.EC2.wordpress_app_b_id

}


module "security" {

  source     = "./modules/security"
  env_prefix = var.env_prefix
  my_ip      = var.my_ip
  vpc_id     = module.vpc.vpc_id 
}


module "EC2" {
  source = "./modules/EC2"

  env_prefix              = var.env_prefix
  ami_owners              = var.ami_owners
  ami_name_pattern        = var.ami_name_pattern
  ami_virtualization_type = var.ami_virtualization_type
  ssh_key_name            = var.ssh_key_name
  public_key_location     = var.public_key_location
  instance_type           = var.instance_type
  aws_region              = var.aws_region
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = var.db_password
  db_endpoint             = module.rds.db_endpoint


  bastion_sg_id   = module.security.bastion_sg_id
  wordpress_sg_id = module.security.wordpress_app_sg_id


  public_subnet_a_id            = module.vpc.public_subnet_a_id
  wordpress_a_private_subnet_id = module.vpc.wordpress_a_private_subnet_id
  wordpress_b_private_subnet_id = module.vpc.wordpress_b_private_subnet_id
}















































