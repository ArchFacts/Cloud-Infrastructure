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

variable "rds_subnet_group_name" {
  description = "Nome do grupo de subnets para o RDS"
  type        = string
}

variable "rds_sg_id" {
  description = "ID do Security Group do RDS"
  type        = string
}