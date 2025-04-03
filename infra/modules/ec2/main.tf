resource "aws_instance" "ArchFacts_Public_Instance" {
  count                       = var.public_instance_count         // Quantidade de instâncias
  ami                         = var.ami_id                        // Imagem da EC2
  instance_type               = var.instance_type                 // Tipo da instância
  subnet_id                   = var.subnet_id_public[count.index] // ID PÚBLICO da subnet
  associate_public_ip_address = true                              // Associar ip público para a máquina
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id] // Associando SG a máquina

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "Public-${var.instance_name}-${count.index + 1}"
  }
}

resource "aws_instance" "ArchFacts_Private_Instance" {
  count                       = var.private_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id_private[count.index]
  associate_public_ip_address = false
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id] // Associando SG a máquina

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "Private-${var.instance_name}-${count.index + 1}"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "sg_ec2"
  description = "Permitir conexões SSH e HTTP"
  vpc_id      = aws_vpc.ArchFacts_Main_VPC.id

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
