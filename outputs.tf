

output "bastion_public_ip" {
  value = module.EC2.bastion_public_ip 
}

output "aws_ami_id" {
  value = module.EC2.ami_id 
}