resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  for_each = local.public_subnet_map
  vpc_id   = aws_vpc.this.id

  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "this" {
  for_each = var.security_groups
  vpc_id   = aws_vpc.this.id
  name     = "${var.name}-${each.key}-sg"
}

resource "aws_security_group_rule" "ingress_cidr" {
  for_each = { for i, r in local.ingress_cidr : "${r.sg}-${i}" => r }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.value.sg].id

  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol
  cidr_blocks = each.value.rule.cidr_blocks
}

resource "aws_security_group_rule" "ingress_sg" {
  for_each = { for i, r in local.ingress_sg : "${r.sg}-${i}" => r }

  type                     = "ingress"
  security_group_id        = aws_security_group.this[each.value.sg].id
  source_security_group_id = aws_security_group.this[each.value.ref].id

  from_port = each.value.rule.from_port
  to_port   = each.value.rule.to_port
  protocol  = each.value.rule.protocol
}

resource "aws_security_group_rule" "egress" {
  for_each = { for i, r in local.egress_all : "${r.sg}-${i}" => r }

  type              = "egress"
  security_group_id = aws_security_group.this[each.value.sg].id

  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol
  cidr_blocks = each.value.rule.cidr_blocks
}