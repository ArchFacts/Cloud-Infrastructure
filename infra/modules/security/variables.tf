variable "instance_name" {
  description = "Nome da instancia EC2"
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

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de IDs das subnets publicas"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "lista de IDs das subnets privadas"
  type        = list(string)
}
