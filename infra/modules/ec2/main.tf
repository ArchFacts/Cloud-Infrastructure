resource "aws_instance" "ArchFacts_Public_Instance" {
  count                       = var.public_instance_count // Quantidade de instâncias
  ami                         = var.ami_id // Imagem da EC2
  instance_type               = var.instance_type // Tipo da instância
  subnet_id                   = var.subnet_id_public // ID PÚBLICO da subnet
  associate_public_ip_address = true // Associar ip público para a máquina

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "${var.instance_name}-${count.index + 1}"
  }
}

resource "aws_instance" "ArchFacts_Private_Instance" {
  count                       = var.private_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id_private
  associate_public_ip_address = false

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "${var.instance_name}-${count.index + 1}"
  }
}