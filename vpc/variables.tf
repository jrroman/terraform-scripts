variable "blacklisted_azs" {
  type    = list(string)
  default = [""]
}

variable "cidr_newbits" {
  type    = number
  default = 4
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "product_name" {
  type    = string
  default = "terraform-vpc"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

