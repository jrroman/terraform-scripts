provider "aws" {
  region = var.region
}

locals {
  product_tags = {
    "Name"        = "${var.product-name}"
    "Environment" = "${var.environment}"
  }
}

data "aws_availability_zones" "available-azs" {
  state                 = "available"
  blacklisted_zone_ids  = "${var.blacklisted-azs}"
}

resource "aws_vpc" "main" {
  cidr_block            = "${var.vpc-cidr}"
  enable_dns_hostnames  = true 

  tags = "${local.product_tags}"
}

resource "aws_subnet" "public" {
  count                   = "${length(aws_availability_zones.available-azs)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8 count.index)}"
  availability_zone       = "${element(aws_availability_zones.available-azs, count.index)}"
  map_public_ip_on_launch = true
  
  tags = {
    "Name" = "Public subnet - ${element(aws_availability_zones.available-azs, count.index)}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = "${local.product_tags}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  depends_on = ["${aws_internet_gateway.main.id}"]

  tags = {
    "Name" = "Public Routing Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id       = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id  = "${aws_route_table.public.id}"
}

resource "aws_subnet" "private" {
  count                   = "${length(aws_availability_zones.available-azs)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.vpc-cidr, 8 count.index)}"
  availability_zone       = "${element(aws_availability_zones.available-azs, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private subnet - ${element(aws_availability_zones.available-azs, count.index)}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = "${length(aws_availability_zones.available-azs)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  tags = {
    "Name" = "NAT - ${element(aws_availability_zones.available-azs, count.index)}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    count           = "${length(aws_availability_zones.available-azs)}"
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = "${element(aws_nat_gateway.main.*.id, count.index)}"
  }

  depends_on = ["${aws_internet_gateway.main.id}"]

  tags = {
    "Name" = "Public Routing Table"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id       = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id  = "${aws_route_table.private.id}"
}
