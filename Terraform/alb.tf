resource "aws_lb" "alb_ecs" {
  name               = "aws-lab-ecs-lb"
  load_balancer_type = "application"
  security_groups    = [module.vpc.default_security_group_id, aws_security_group.allow_http.id]
  subnets            = module.vpc.public_subnets
  #vpc_id             = module.vpc.vpc_id
  #depends_on         = [module.vpc]
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_listener_https" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = module.wildcard_cert.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_listener" "ecs_listener_http" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = "80"
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


data "aws_route53_zone" "this" {
  name = "aws.yanovsky.cc"
}

# module "acm" {
#   source  = "terraform-aws-modules/acm/aws"
#   version = "~> 4.0"

#   domain_name = "lab.aws.yanovsky.cc"
#   zone_id     = data.aws_route53_zone.this.id
# }

module "wildcard_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = "*.aws.yanovsky.cc"
  zone_id     = data.aws_route53_zone.this.id
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.this.id
  name    = "lab"
  type    = "CNAME"
  records = [aws_lb.alb_ecs.dns_name]
  ttl     = 60

  depends_on = [aws_lb.alb_ecs]
}

output "url" { value = "http://${aws_lb.alb_ecs.dns_name}" }
