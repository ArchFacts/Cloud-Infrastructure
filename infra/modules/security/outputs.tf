output "sg_id" {
  description = "ID do security group da EC2"
  value = aws_security_group.ec2_sg.id
}