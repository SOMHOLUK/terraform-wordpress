output "rds_sg_id" {
    value = aws_security_group.rds-database-security-group.id
}

output "alb_sg_id" {
    value = aws_security_group.alb-security-group.id
}





output "bastion_sg_id" { value = aws_security_group.bastion-host-security-group.id }

output "wordpress_app_sg_id" { value = aws_security_group.wordpress-app-security-group.id }

