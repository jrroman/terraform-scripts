variable "blacklisted-azs" {
  type    = list(string)
  default = [""]
}

variable "environment" {
  default = "staging"
}

variable "product-name" {
  default = "tf-build"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

