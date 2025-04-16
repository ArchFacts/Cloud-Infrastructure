output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.ArchFacts_Main_VPC.id
}

output "public_subnet_ids" {
  description = "IDs das subnets PÚBLICAS"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "IDs das subnets PRIVADAS"
  value       = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  description = "ID do Nat Gateway"
  value       = var.nat_gateway_enabled ? aws_nat_gateway.nat_gateway[0].id : null
}

output "vpc_cidr_block" {
  description = "bloco CIDR da VPC"
  value       = aws_vpc.ArchFacts_Main_VPC.cidr_block
}

output "public_subnet_cidrs" {
  description = "Os CIDRs da subrede PÚBLICA"
  value       = aws_subnet.public_subnet[*].cidr_block
}
