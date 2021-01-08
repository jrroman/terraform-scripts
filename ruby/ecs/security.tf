resource "aws_security_group" "alb" {
  name        = "${var.product-name}-alb-sg"
  description = "controls access to the ALB"
  vpc_id      = var.vpc-id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.product-name}-ecs-task-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc-id

  ingress {
    protocol        = "tcp"
    from_port       = var.app-port
    to_port         = var.app-port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
