variable "blacklisted-azs" {
  type    = list(string)
  default = [""]
}

variable "cidr-newbits" {
  default = 4
}

variable "environment" {
  default = "staging"
}

variable "product-name" {
  default = "terraform-vpc"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

