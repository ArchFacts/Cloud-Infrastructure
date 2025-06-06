variable "cidr_block" {
  description = "Bloco CIDR para a VPC"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Os CIDRs da subrede PUBLICA"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Os CIDRs da subrede PRIVADA"
  type        = list(string)
}

variable "nat_gateway_enabled" {
  description = "Habilitacao do NAT Gateway para a subrede"
  type        = bool
}

variable "nat_gateway_subnet_index" {
  description = "Valor do indice da subnet publica que sera alocada ao NAT Gateway"
  type        = number
  default     = 0
}
