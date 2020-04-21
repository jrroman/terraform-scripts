resource "aws_cloudwatch_log_group" "main_log_group" {
  name              = "/ecs/${var.product-name}"
  retention_in_days = 30

  tags = {
    Name = "${var.product-name}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "main_log_stream" {
  name           = "${var.product-name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.main_log_group.name
}
