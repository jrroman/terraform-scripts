resource "aws_alb" "main" {
  name            = "${var.product-name}-${var.environment}-alb"
  subnets         = data.aws_subnet_ids.public.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "main_app" {
  name        = "${var.product-name}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health-check-path
    unhealthy_threshold = "2"
  }

  tags = local.product_tags
}

resource "aws_alb_listener" "httpEp" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_alb_listener" "httpsEp" {
  load_balancer_arn = aws_alb.main.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm-certificate-arn


  default_action {
    target_group_arn = aws_alb_target_group.main_app.id
    type             = "forward"
  }
}

