
resource "aws_lb_target_group" "wordpress-tg" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      =  var.target_group_vpc_id 
  target_type = var.target_type 

}


resource "aws_lb" "application-load-balancer" {
  name               = "${var.env_prefix}-application-load-balancer"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            =  var.subnet_ids

  enable_deletion_protection = false


  tags = {
    Name = "${var.env_prefix}-Application-Load-Balancer"
  }
}



resource "aws_lb_listener" "alb_http_redirect" {
  load_balancer_arn = aws_lb.application-load-balancer.arn 
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "alb_https" {
  load_balancer_arn = aws_lb.application-load-balancer.arn 
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy 
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn  
  }
}


resource "aws_lb_target_group_attachment" "wordpress-attachment-a" {
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = var.wordpress_instance_id_a
  port             = var.target_group_port
}


resource "aws_lb_target_group_attachment" "wordpress-attachment-b" {
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = var.wordpress_instance_id_b
  port             = var.target_group_port
}





