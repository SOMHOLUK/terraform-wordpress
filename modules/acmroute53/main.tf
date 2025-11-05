
resource "aws_acm_certificate" "wordpress_cert" {
  domain_name       = var.domain_name 
  validation_method = "DNS"

  tags = {
    Name = "${var.env_prefix}-WordPress-ACM-Cert"
  }


}


resource "aws_acm_certificate_validation" "wordpress_cert" {
  certificate_arn         = aws_acm_certificate.wordpress_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}


resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name   
  type    = "A"

  alias {
    name                   = var.alb_dns_name 
    zone_id                = var.alb_zone_id 
    evaluate_target_health = true
  }
}


resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wordpress_cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}



data "aws_route53_zone" "primary" {
  zone_id = var.route53_zone_id 
}
