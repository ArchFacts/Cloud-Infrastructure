variable "aws_region" {
  description = "Qual região será utilizada na AWS"
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
  description = "Lista de CIDRs para as subnets PÚBLICAS"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDRs para as subnets PRIVADAS"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Valor BOOLEAN para habilitação do NAT Gateway para subnets privadas"
  type        = bool
  default     = true
}

variable "nat_gateway_subnet_index" {
  description = "Valor do índice da subnet pública onde o NAT Gateway será aplicado"
  type        = number
  default     = 0
}

####################################### EC2 VARIABLES

variable "key_name" {
  description = "Nome da chave SSH para o acesso à EC2"
  type        = string
}

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
  default     = "t2.micro"
}

variable "public_instance_count" {
  description = "Quantidade de instâncias públicas EC2 a serem criadas"
  type        = number
  default     = 1
}

variable "private_instance_count" {
  description = "Quantidade de instâncias privadas EC2 a serem criadas"
  type        = number
  default     = 1
}

# Caminho da chave
variable "key_path" {
  description = "Caminho da chave privada no computador"
  type        = string
}

# Variáveis do RDS
variable "rds_subnet_group_name" {
  description = "Nome do grupo de subnets para o RDS"
  type        = string
}

variable "db_user" {
  description = "O nome do usuário do banco de dados"
  type        = string

}

variable "db_password" {
  description = "A senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "O nome do banco de dados"
  type        = string
}
