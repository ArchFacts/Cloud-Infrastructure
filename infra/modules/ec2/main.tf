resource "aws_instance" "ArchFacts_Public_Instance" {
  count                       = var.public_instance_count         // Quantidade de instâncias
  ami                         = var.ami_id                        // Imagem da EC2
  instance_type               = var.instance_type                 // Tipo da instância
  subnet_id                   = var.subnet_id_public[count.index] // ID PÚBLICO da subnet
  associate_public_ip_address = true                              // Associar ip público para a máquina
  key_name                    = aws_key_pair.ArchFacts_Key.key_name
  vpc_security_group_ids      = [var.sg_public_id] // Associando SG a máquina

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "Public-${var.instance_name}-${count.index + 1}"
  }

  depends_on = [aws_key_pair.ArchFacts_Key] // Para garantir que a ordem de criação será feita corretamente
}

resource "aws_instance" "ArchFacts_Private_Instance" {
  count                       = var.private_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id_private[count.index]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.ArchFacts_Key.key_name
  vpc_security_group_ids      = [var.sg_private_id] // Associando SG a máquina

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Name        = "Private-${var.instance_name}-${count.index + 1}"
  }

  depends_on = [aws_key_pair.ArchFacts_Key]
}

resource "aws_key_pair" "ArchFacts_Key" {
  key_name   = var.key_name
  public_key = var.public_key_content
}
