resource "aws_vpc" "ArchFacts_Main_VPC" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.ArchFacts_Main_VPC.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count      = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.ArchFacts_Main_VPC.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.ArchFacts_Main_VPC.id

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "internet_gateway-${var.vpc_name}"
  }
}

resource "aws_route_table" "ig_route_table" {
  vpc_id = aws_vpc.ArchFacts_Main_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "ig_route_table-${var.vpc_name}"
  }
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.ig_route_table.id
}

#IP ELÁSTICO OBRIGATÓRIO PARA O NAT_GATEWAY
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "eip-nat-gateway-${var.vpc_name}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "nat_gateway_public_subnet-${var.vpc_name}"
  }
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.ArchFacts_Main_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "nat_route_table-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat_route_table.id
}