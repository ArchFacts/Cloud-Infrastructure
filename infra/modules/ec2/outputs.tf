############################################## INSTANCIAS PUBLICAS
output "public_instance_ids" {
  description = "IDs das instancias publicas EC2 criadas"
  value       = aws_instance.ArchFacts_Public_Instance[*].id
}

output "public_instance_public_ips" {
  description = "IPs publicos das instancias publicas EC2"
  value       = aws_instance.ArchFacts_Public_Instance[*].public_ip
}

############################################## INSTANCIAS PRIVADAS
output "private_instance_ids" {
  description = "IDs das instancias privadas EC2 criadas"
  value       = aws_instance.ArchFacts_Private_Instance[*].id
}

output "private_instance_private_ips" {
  description = "IPs privados das instancias privadas EC2"
  value       = aws_instance.ArchFacts_Private_Instance[*].private_ip
}