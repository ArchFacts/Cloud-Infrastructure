variable "instance_name" {
  description = "Nome da instância EC2"
  type        = string
}

variable "ami_id" {
  description = "ID da instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância"
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
  description = "ID da subnet PÚBLICA da EC2"
  type        = string
}

variable "subnet_id_private" {
  description = "ID da subnet PRIVADA da EC2"
  type        = string
}

# variable "public_ip" {
#   description = "Se a instância deve receber um IP público ou não"
#   type        = bool
# }
