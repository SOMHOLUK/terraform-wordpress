output "wordpress_app_a_id" {
    value = aws_instance.wordpress-app-a.id
}

output "wordpress_app_b_id" {
    value = aws_instance.wordpress-app-b.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion-host.public_ip
}

output "ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}