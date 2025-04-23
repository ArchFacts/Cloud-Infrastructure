variable "cidr_block" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Os CIDRs da subrede PÚBLICA"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Os CIDRs da subrede PRIVADA"
  type        = list(string)
}

variable "nat_gateway_enabled" {
  description = "Habilitação do NAT Gateway para a subrede"
  type        = bool
}

variable "nat_gateway_subnet_index" {
  description = "Valor do índice da subnet pública que será alocada ao NAT Gateway"
  type        = number
  default     = 0
}

variable "rds_subnet_group_name" {
  description = "Nome do grupo de subnets para o RDS"
  type        = string
}