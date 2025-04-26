output "rds_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.ArchFactsDB.address
}

output "rds_port" {
  description = "Porta para acessar o RDS"
  value       = aws_db_instance.ArchFactsDB.port
}

output "rds_database" {
  description = "value do banco de dados"
  value       = aws_db_instance.ArchFactsDB.db_name
}

output "rds_user" {
  description = "Usuário do banco de dados"
  value       = aws_db_instance.ArchFactsDB.username
}

output "rds_password" {
  description = "Senha do banco de dados"
  value       = aws_db_instance.ArchFactsDB.password
  sensitive   = true
}