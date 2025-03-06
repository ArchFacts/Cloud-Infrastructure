############################################## INSTÂNCIAS PÚBLICAS
output "public_instance_ids" {
  description = "IDs das instâncias públicas EC2 criadas"
  value       = aws_instance.ArchFacts_Public_Instance[*].id
}

output "public_instance_public_ips" {
  description = "IPs públicos das instâncias públicas EC2"
  value       = aws_instance.ArchFacts_Public_Instance[*].public_ip
}

############################################## INSTÂNCIAS PRIVADAS
output "private_instance_ids" {
  description = "IDs das instâncias privadas EC2 criadas"
  value       = aws_instance.ArchFacts_Private_Instance[*].id
}

output "private_instance_private_ips" {
  description = "IPs privados das instâncias privadas EC2"
  value       = aws_instance.ArchFacts_Private_Instance[*].private_ip
}