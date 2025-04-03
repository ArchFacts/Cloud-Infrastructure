variable "instance_name" {
  description = "Nome da instância EC2"
  type        = string
}

variable "ami_id" {
  description = "ID da instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "public_instance_count" {
  description = "Quantidade de instâncias públicas EC2 a serem criadas"
  type        = number
}

variable "private_instance_count" {
  description = "Quantidade de instâncias privadas EC2 a serem criadas"
  type        = number
}

variable "subnet_id_public" {
  description = "Lista de IDs da subnet PÚBLICA da EC2"
  type        = list(string)
}

variable "subnet_id_private" {
  description = "Lista de IDs da subnet PRIVADA da EC2"
  type        = list(string)
}

variable "key_name" {
  description = "Nome da chave SSH para o acesso das EC2"
  type        = string
}

variable "sg_id" {
  description = "ID do security group da EC2"
  type        = string
}

variable "public_key_content" {
  description = "Caminho da chave pública para acesso da EC2"
  type        = string
}
