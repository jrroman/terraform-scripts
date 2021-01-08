provider "aws" {
  region = var.region
}

locals {
  product_tags = {
    "Name"        = var.product-name
    "Environment" = var.environment
  }
  full-name         = "${var.product-name}-${var.environment}"
  cluster-name      = "${var.product-name}-${var.environment}-cluster"
  service-name      = "${var.product-name}-${var.environment}-service"
  task-family-name  = "${var.product-name}-${var.environment}-task"
}

resource "aws_ecs_cluster" "main" {
  name = local.cluster-name

  tags = local.product_tags
}

data "template_file" "main_app" {
  template = file("./templates/ecs/main_app.json.tpl")

  vars = {
    app_image       = var.app-image
    app_name        = local.task-family-name
    app_port        = var.app-port
    stage           = var.environment
    fargate_cpu     = var.fargate-cpu
    fargate_memory  = var.fargate-memory
    master_key      = var.rails-master-key
    product_name    = local.full-name
    region          = var.region
  }
}

resource "aws_ecs_task_definition" "main_app" {
  family                    = local.task-family-name
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.fargate-cpu
  memory                    = var.fargate-memory
  container_definitions     = data.template_file.main_app.rendered

  tags = local.product_tags
}

resource "aws_ecs_service" "main" {
  name                                      = local.service-name
  cluster                                   = aws_ecs_cluster.main.id
  task_definition                           = aws_ecs_task_definition.main_app.arn
  desired_count                             = var.app-count
  deployment_maximum_percent                = 200
  deployment_minimum_healthy_percent        = 100
  launch_type                               = "FARGATE"
  health_check_grace_period_seconds         = 400

  network_configuration {
    security_groups   = [aws_security_group.ecs_tasks.id]
    subnets           = data.aws_subnet_ids.private.ids
    assign_public_ip  = false
  }

  load_balancer {
    target_group_arn  = aws_alb_target_group.main_app.id
    container_name    = local.task-family-name
    container_port    = var.app-port
  }

  depends_on = [aws_alb_listener.httpsEp, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = local.product_tags
}

