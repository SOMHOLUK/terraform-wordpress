output "alb_dns_name" {
  value       = aws_lb.application-load-balancer.dns_name
}

output "alb_zone_id" {
  value       = aws_lb.application-load-balancer.zone_id
}

