#Variáveis para EC2
instance_name          = "ArchFacts-Instance"
ami_id                 = "ami-04b4f1a9cf54c11d0"
instance_type          = "t2.micro"
public_instance_count  = 1
private_instance_count = 1
key_name               = "ArchFacts_Public-EC2-Key"
key_path               = "~/.ssh/ArchFacts-EC2-Key.pem"

#Variáveis para a VPC
vpc_cidr           = "10.0.0.0/23"
public_subnets     = ["10.0.0.0/25"]
private_subnets    = ["10.0.0.128/25"]
enable_nat_gateway = true

#Variáveis para o container MySQL
db_user               = "ArchFactsApplication"
db_password           = "SociaLightArchFacts"
db_name               = "ArchFactsDB"
rds_subnet_group_name = "archfacts-db-subnet-group"
