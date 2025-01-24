data "aws_availability_zones" "available" {}

###############################################################################
# VPC
###############################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.namespace}-${var.environment}-vpc"
  }
}

###############################################################################
# Internet Gateway
###############################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.namespace}-${var.environment}-ig"
  }
}

###############################################################################
# Public Subnets & Public Route Tables
###############################################################################

resource "aws_subnet" "public" {
  count = var.az_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, 100 + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${var.namespace}-${var.environment}-public-subnet-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-public-rt"
  }
}

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public" {
  count = var.az_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

###############################################################################
# NAT Gateway
###############################################################################

resource "aws_eip" "nat_gw_eip" {
  count = var.az_count

  tags = {
    "Name" = "${var.namespace}-${var.environment}-eip-${count.index}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.az_count

  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gw_eip[count.index].id

  tags = {
    "Name" = "${var.namespace}-${var.environment}-nat-gw-${count.index}"
  }
}

###############################################################################
# Private Subnets & Public Route Tables
###############################################################################

resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name"                            = "${var.namespace}-private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count = var.az_count

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.namespace}-private-subnet-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = var.az_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
