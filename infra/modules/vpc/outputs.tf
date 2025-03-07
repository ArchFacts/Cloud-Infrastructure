output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.ArchFacts_Main_VPC
}

output "public_subnet_ids" {
  description = "IDs das subnets PÚBLICAS"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets PRIVADAS"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "ID do Nat Gateway"
  value       = var.nat_gateway_enabled ? aws_nat_gateway.this[0].id : null
}
