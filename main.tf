data "aws_availability_zones" "this" { state = "available" }

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_prefix.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = format("%s-%s-vpc-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.vpc_prefix.prefix, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    # Name = format("%s-%s-vpc-%s-%02d", var.pj_tags.name, var.pj_tags.env, each.key, index(local.vpc_count, each.key))
    Name = format("%s-%s-igw-%s-%02d", var.pj_tags.name, var.pj_tags.env, var.vpc_prefix.prefix, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_subnet" "pub" {
  #   for_each = var.subnet_resources.pub
  for_each                = var.subnet.pub
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = format("%s%s", data.aws_availability_zones.this.id, each.value.az)
  map_public_ip_on_launch = each.value.is_public_subnet
  tags = {
    Name = format("%s-%s-snt-%s-%s-%02d", var.pj_tags.name, var.pj_tags.env, each.value.prefix, each.value.az, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "pri" {
  for_each                = var.subnet.pri
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = format("%s%s", data.aws_availability_zones.this.id, each.value.az)
  map_public_ip_on_launch = each.value.is_public_subnet
  tags = {
    Name = format("%s-%s-snt-%s-%s-%02d", var.pj_tags.name, var.pj_tags.env, each.value.prefix, each.value.az, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "edp" {
  for_each                = var.subnet.edp
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = format("%s%s", data.aws_availability_zones.this.id, each.value.az)
  map_public_ip_on_launch = each.value.is_public_subnet
  tags = {
    Name = format("%s-%s-snt-%s-%s-%02d", var.pj_tags.name, var.pj_tags.env, each.value.prefix, each.value.az, 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-%s-rtb-%s-%02d", var.pj_tags.name, var.pj_tags.env, "pub", 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-%s-rtb-%s-%02d", var.pj_tags.name, var.pj_tags.env, "pri", 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_route_table" "edp" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format("%s-%s-rtb-%s-%02d", var.pj_tags.name, var.pj_tags.env, "edp", 1)
    PJ   = var.pj_tags.name
    Env  = var.pj_tags.env
  }
}

resource "aws_route" "pub" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.pub.id
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pub" {
  for_each       = { for k, v in var.subnet.pub : k => v if v.is_public_subnet }
  subnet_id      = aws_subnet.pub[each.key].id
  route_table_id = aws_route_table.pub.id
}