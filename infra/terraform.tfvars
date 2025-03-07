#Variáveis para EC2
instance_name          = "ArchFacts-Instance"
ami_id                 = "ami-04b4f1a9cf54c11d0"
instance_type          = "t2.micro"
public_instance_count  = 1
private_instance_count = 1

#Variáveis para a VPC
vpc_cidr           = "10.0.0.0/24"
public_subnets     = ["10.0.0.0/25"]
private_subnets    = ["10.0.0.128/25"]
enable_nat_gateway = true
