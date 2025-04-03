
export $(grep -v '^#' .env | xargs)

terraform init
terraform apply