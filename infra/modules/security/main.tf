resource "aws_security_group" "ec2_sg" {
  name        = "sg_ec2"
  description = "Permitir conexões SSH e HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "sg-${var.instance_name}"
  }
}


resource "aws_network_acl" "main_acl" {
  vpc_id = var.vpc_id

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
  subnet_id      = var.public_subnet_ids[count.index]
}

resource "aws_network_acl_association" "private_acl_association" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = var.private_subnet_ids[count.index]
}
