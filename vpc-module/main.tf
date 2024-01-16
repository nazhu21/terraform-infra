################################################################################
# VPC
################################################################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = var.vpc_tenancy

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "elastic_ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gtw" {
  connectivity_type = var.nat_connectivity_type
  allocation_id     = aws_eip.elastic_ip.id
  subnet_id         = aws_subnet.public_subnets[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gtw"
  }

  depends_on = [aws_internet_gateway.igw, aws_subnet.public_subnets, aws_eip.elastic_ip]
}

################################################################################
# Route Tables
################################################################################

###### Public RT ######
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.destination_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

###### Private RT ######

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.destination_cidr
    gateway_id = aws_nat_gateway.nat_gtw.id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}


################################################################################
# VPC Subnets
################################################################################

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "${var.vpc_name}-pub-sub-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.private_subnet_azs[count.index]
  tags = {
    Name = "${var.vpc_name}-priv-sub-${count.index + 1}"
  }
}

###### Subnet Associations ######

resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(aws_subnet.public_subnets)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(aws_subnet.private_subnets)
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}


