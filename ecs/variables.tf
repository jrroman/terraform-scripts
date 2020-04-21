variable "app-count" {
  default = 2
}

variable "app-image" {}

variable "app-port" {
  default = 3000
}

variable "environment" {
  default = "staging"
}

variable "ecs-task-execution-role-name" {
  default = "ecsTaskExecutionRole"
}

variable "health-check-path" {
  default = "/"
}

variable "fargate-cpu" {
  default = "1024"
}

variable "fargate-memory" {
  default = "2048"
}

variable "product-name" {
  default = "terraform-ecs"
}

variable "region" {
  default = "us-east-1"
}

variable "acm-certificate-arn" {}
variable "rails-master-key" {}
variable "vpc-id" {}

