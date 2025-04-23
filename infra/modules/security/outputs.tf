output "sg_public_id" {
  description = "ID do security group PÚBLICO da EC2"
  value       = aws_security_group.public_ec2_sg.id
}

output "sg_private_id" {
  description = "ID do security group PRIVADO da EC2"
  value       = aws_security_group.private_ec2_sg.id
}

output "rds_sg_id" {
  description = "ID do security group do RDS"
  value       = aws_security_group.sg_rds.id
}
