resource "aws_security_group" "public_ec2_sg" {
  name        = "sg_public_ec2"
  description = "Permitir conexoes SSH e HTTP"
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

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_security_group" "private_ec2_sg" {
  name        = "sg_private_ec2"
  description = "Permitir conexoes SSH e HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_acl" "public_acl" {
  vpc_id = var.vpc_id

  # ingress {
  #   rule_no    = 100
  #   action     = "allow"
  #   protocol   = "tcp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 22
  #   to_port    = 22
  # }

  # ingress {
  #   rule_no    = 105
  #   action     = "allow"
  #   protocol   = "icmp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 0
  #   to_port    = 0
  # }

  # ingress {
  #   rule_no    = 110
  #   action     = "allow"
  #   protocol   = "tcp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 80
  #   to_port    = 80
  # }

  # ingress {
  #   rule_no    = 115
  #   action     = "allow"
  #   protocol   = "tcp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 5000
  #   to_port    = 5000
  # }


  # ingress {
  #   rule_no    = 120
  #   action     = "allow"
  #   protocol   = "tcp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 32768
  #   to_port    = 60999
  # }

  # ingress {
  #   rule_no    = 125
  #   action     = "allow"
  #   protocol   = "tcp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = 1024
  #   to_port    = 65535
  # }

  # ingress {
  #   rule_no    = 135
  #   action     = "allow"
  #   protocol   = "icmp"
  #   cidr_block = "0.0.0.0/0"
  #   from_port  = "-1"
  #   to_port    = "-1"
  # }

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  egress {
    rule_no    = 130
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "acl-public-${var.vpc_name}"
  }
}

resource "aws_network_acl" "private_acl" {
  vpc_id = var.vpc_id

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 110
    action     = "allow"
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "acl-private-${var.vpc_name}"
  }
}

resource "aws_network_acl_association" "public_acl_association" {
  count          = length(var.public_subnet_cidrs)
  network_acl_id = aws_network_acl.public_acl.id
  subnet_id      = var.public_subnet_ids[count.index]
}

resource "aws_network_acl_association" "private_acl_association" {
  count          = length(var.private_subnet_cidrs)
  network_acl_id = aws_network_acl.private_acl.id
  subnet_id      = var.private_subnet_ids[count.index]
}

resource "aws_security_group" "sg_rds" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_ec2_sg.id]
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
    Name        = "sg-rds-${var.instance_name}"
  }
}
