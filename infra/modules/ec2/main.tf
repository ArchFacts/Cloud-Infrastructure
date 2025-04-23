resource "aws_instance" "ArchFacts_Public_Instance" {
  count                       = var.public_instance_count         // Quantidade de instâncias
  ami                         = var.ami_id                        // Imagem da EC2
  instance_type               = var.instance_type                 // Tipo da instância
  subnet_id                   = var.subnet_id_public[count.index] // ID PÚBLICO da subnet
  associate_public_ip_address = true                              // Associar ip público para a máquina
  key_name                    = aws_key_pair.ArchFacts_Key.key_name
  vpc_security_group_ids      = [var.sg_public_id] // Associando SG a máquina
  user_data                   = file("${path.module}/../../scripts/docker_config.sh")

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
  user_data                   = file("${path.module}/../../scripts/docker_config.sh")

  # provisioner "remote-exec" {
  #   inline = [
  #     "export DB_ROOT_PASSWORD='${var.db_root_password}'",
  #     "export DB_USER='${var.db_user}'",
  #     "export DB_PASSWORD='${var.db_password}'",
  #     "export DB_NAME='${var.db_name}'",
  #     "export MYSQL_IMAGE_TAG='mysql:8.0'",
  #     "export MYSQL_VOLUME_NAME='mysql_data'",
  #     "export MYSQL_CONTAINER_NAME='mysql-container-ArchFacts'", #
  #     "export MYSQL_PORT='3306'",

  #     "set -e",

  #     "echo 'Iniciando script de configuração do MySQL Docker (via inline)...'",


  #     "if ! docker volume inspect \"$MYSQL_VOLUME_NAME\" > /dev/null 2>&1; then",
  #     "  echo 'Criando Volume Docker: $MYSQL_VOLUME_NAME'",
  #     "  docker volume create \"$MYSQL_VOLUME_NAME\"",
  #     "else",
  #     "  echo 'Volume Docker $MYSQL_VOLUME_NAME já existe'",
  #     "fi",

  #     "echo 'Puxando Imagem Docker: $MYSQL_IMAGE_TAG'",
  #     "docker pull \"$MYSQL_IMAGE_TAG\"",

  #     "if ! docker container inspect \"$MYSQL_CONTAINER_NAME\" > /dev/null 2>&1; then",
  #     "  echo 'Rodando Container Docker: $MYSQL_CONTAINER_NAME'",

  #     "  docker run -d --name \"$MYSQL_CONTAINER_NAME\" \\",
  #     "    -p \"$MYSQL_PORT\":\"$MYSQL_PORT\" \\",
  #     "    -v \"$MYSQL_VOLUME_NAME\":/var/lib/mysql \\",
  #     "    -e MYSQL_ROOT_PASSWORD=\"$DB_ROOT_PASSWORD\" \\",
  #     "    -e MYSQL_DATABASE=\"$DB_NAME\" \\",
  #     "    -e MYSQL_USER=\"$DB_USER\" \\",
  #     "    -e MYSQL_PASSWORD=\"$DB_PASSWORD\" \\",
  #     "    \"$MYSQL_IMAGE_TAG\"",
  #     "else",
  #     "  echo 'Container Docker $MYSQL_CONTAINER_NAME já existe'",
  #     "fi",

  #     "echo 'Configuração do MySQL Docker concluída (inline).'"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file(var.key_path)
  #     host        = self.private_ip

  #     bastion_host        = aws_instance.ArchFacts_Public_Instance[0].public_ip
  #     bastion_user        = "ubuntu"
  #     bastion_private_key = file(var.key_path)
  #   }
  # }


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
