variable "aws_region" {
  description = "Qual regiao sera utilizada na AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome utilizado na VPC"
  type        = string
  default     = "ArchFacts_VPC"
}

variable "public_subnets" {
  description = "Lista de CIDRs para as subnets PUBLICAS"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDRs para as subnets PRIVADAS"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Valor BOOLEAN para habilitacaoo do NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_index" {
  description = "Valor do indice da subnet publica onde o NAT Gateway sera aplicado"
  type        = number
  default     = 0
}

####################################### EC2 VARIABLES

variable "key_name" {
  description = "Nome da chave SSH para o acesso à EC2"
  type        = string
}

variable "instance_name" {
  description = "Nome da instancia EC2"
  type        = string
}

variable "ami_id" {
  description = "ID da instancia EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "public_instance_count" {
  description = "Quantidade de instancias publicas EC2 a serem criadas"
  type        = number
  default     = 1
}

variable "private_instance_count" {
  description = "Quantidade de instancias privadas EC2 a serem criadas"
  type        = number
  default     = 1
}
