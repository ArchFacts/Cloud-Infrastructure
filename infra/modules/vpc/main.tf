resource "aws_vpc" "ArchFacts_Main_VPC" {
  cidr_block = var.cidr_block

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
  route_table_id = aws_route_table.nat_route_table[count.index].id
}

resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.ArchFacts_Main_VPC.id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    rule_no    = 200
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 300
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "acl-${var.vpc_name}"
  }
}

resource "aws_network_acl_association" "public_acl_association" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_network_acl_association" "private_acl_association" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}