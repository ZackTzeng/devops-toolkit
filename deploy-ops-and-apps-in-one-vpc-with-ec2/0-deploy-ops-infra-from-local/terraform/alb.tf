# Elastic Load Balancer
resource "aws_lb" "jenkins_alb" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.public_http.id,
    aws_security_group.public_https.id,
    aws_security_group.private_all.id
  ]
  subnets = module.vpc.public_subnets
}

# Listener for ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
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

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.jenkins_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }
}