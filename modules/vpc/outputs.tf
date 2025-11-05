


output "vpc_id" {
  value = aws_vpc.wordpress-vpc.id
}


output "public_subnet_a_id" {
  value = aws_subnet.public-subnet-a.id
}


output "public_subnet_b_id" {
  value = aws_subnet.public-subnet-b.id
}


output "wordpress_a_private_subnet_id" {
  value = aws_subnet.wordpress_a_privatesubnet.id  
}


output "wordpress_b_private_subnet_id" {
  value = aws_subnet.wordpress_b_privatesubnet.id
}


output "rds_a_private_subnet_id" {  
  value = aws_subnet.rds-a-privatesubnet.id
}


output "rds_b_private_subnet_id" {
  value = aws_subnet.rds-b-privatesubnet.id
}
