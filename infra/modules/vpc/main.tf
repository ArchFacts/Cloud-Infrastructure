resource "aws_vpc" "ArchFacts_Main_VPC" {
  cidr_block = var.cidr_block

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.ArchFacts_Main_VPC.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = "us-east-1a"
  
  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.ArchFacts_Main_VPC.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = "us-east-1a"

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
  count = var.nat_gateway_enabled ? 1 : 0
  vpc   = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "eip-nat-gateway-${var.vpc_name}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.nat_gateway_enabled ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[var.nat_gateway_subnet_index].id

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "nat_gateway_public_subnet-${var.vpc_name}"
  }
}

resource "aws_route_table" "nat_route_table" {
  count  = var.nat_gateway_enabled ? 1 : 0
  vpc_id = aws_vpc.ArchFacts_Main_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "nat_route_table-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = var.nat_gateway_enabled ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.nat_route_table[0].id
}

resource "aws_subnet" "dummy_private_subnet" {
  vpc_id            = aws_vpc.ArchFacts_Main_VPC.id
  cidr_block        = "10.0.1.0/27"
  availability_zone = "us-east-1b"

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "dummy_private_subnet-${var.vpc_name}"
  }
}

resource "aws_db_subnet_group" "subnet_group_rds" {
  name       = var.rds_subnet_group_name
  subnet_ids = concat(aws_subnet.private_subnet[*].id, [aws_subnet.dummy_private_subnet.id])

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "subnet_group_rds-${var.vpc_name}"
  }
}
