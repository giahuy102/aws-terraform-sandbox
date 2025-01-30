resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(var.common_tags, {
    Name = "Custom VPC"
  })
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(var.common_tags, {
    Name = "Public Subnet ${count.index + 1}"
  })
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(var.common_tags, {
    Name = "Private Subnet ${count.index + 1}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "Custom VPC IGW"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.common_tags, {
    Name = "Public Route Table"
  })
}

resource "aws_route_table_association" "public_subnet_rt_assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

// Multiple NAT gateways -> Multiple route tables
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway[count.index].id
  }

  tags = merge(var.common_tags, {
    Name = "Private Route Table"
  })
}

resource "aws_route_table_association" "private_subnet_rt_assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_rt[*].id, count.index)
}

resource "aws_eip" "eip_natgw" {
  count = length(var.public_subnet_cidrs)
}

resource "aws_nat_gateway" "natgateway" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.eip_natgw[count.index].id // another beside using `element` function
  subnet_id     = aws_subnet.public_subnets[count.index].id
}
