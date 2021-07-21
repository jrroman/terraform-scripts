terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}

locals {
  full_name = "${var.product_name}-${var.environment}"
}

data "aws_availability_zones" "available-azs" {
  state             = "available"
  exclude_zone_ids  = var.blacklisted_azs

  filter {
    name    = "opt-in-status"
    values  = ["opt-in-not-required"]
  }
}

resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true 

  tags = {
    "Name" = "${local.full_name}-vpc"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "public" {
  count                   = length(data.aws_availability_zones.available-azs.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.cidr_newbits, count.index)
  availability_zone       = element(data.aws_availability_zones.available-azs.names, count.index)
  map_public_ip_on_launch = true
  
  tags = {
    "Name" = "pub-${local.full_name}-${element(data.aws_availability_zones.available-azs.names, count.index)}"
    "Tier" = "Public"
    "Environment" = "${var.environment}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${local.full_name}-igw"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "pub-${local.full_name}-rt"
    "Tier" = "Public"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route" "public" {
  route_table_id              = aws_route_table.public.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count           = length(data.aws_availability_zones.available-azs.names)
  subnet_id       = element(aws_subnet.public.*.id, count.index)
  route_table_id  = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count                   = length(data.aws_availability_zones.available-azs.names)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, var.cidr_newbits, count.index + length(data.aws_availability_zones.available-azs.names))
  availability_zone       = element(data.aws_availability_zones.available-azs.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "priv-${local.full_name}-${element(data.aws_availability_zones.available-azs.names, count.index)}"
    "Tier" = "Private"
    "Environment" = "${var.environment}"
  }
}

resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available-azs.names)
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = length(data.aws_availability_zones.available-azs.names)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat.*.id, count.index)

  tags = {
    "Name" = "nat-${local.full_name}-${element(data.aws_availability_zones.available-azs.names, count.index)}"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route_table" "private" {
  count   = length(data.aws_availability_zones.available-azs.names)
  vpc_id  = aws_vpc.main.id

  tags = {
    "Name" = "priv-${local.full_name}-rt"
    "Tier" = "Private"
    "Environment" = "${var.environment}"
  }
}

resource "aws_route" "private" {
  count                       = length(data.aws_availability_zones.available-azs.names)
  route_table_id              = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count           = length(data.aws_availability_zones.available-azs.names)
  subnet_id       = element(aws_subnet.private.*.id, count.index)
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}
