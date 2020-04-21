data "aws_subnet_ids" "private" {
  vpc_id = var.vpc-id
  filter {
    name    = "tag:Tier"
    values  = ["Private"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc-id
  filter {
    name    = "tag:Tier"
    values  = ["Public"]
  }
}
