resource "aws_cloudwatch_log_group" "main_log_group" {
  name              = "/ecs/${local.full-name}"
  retention_in_days = 30

  tags = {
    Name = "${local.full-name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "main_log_stream" {
  name           = "${local.full-name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.main_log_group.name
}