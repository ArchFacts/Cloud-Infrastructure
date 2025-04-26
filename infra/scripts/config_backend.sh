#!/bin/bash

# Atualiza os pacotes e instala dependências necessárias
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl

# Cria o diretório de keyrings e adiciona a chave GPG oficial do Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adiciona o repositório do Docker às fontes do Apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza os pacotes e instala as versões mais recentes do Docker e plugins
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Inicia o Docker e habilita para iniciar automaticamente no boot
sudo systemctl start docker
sudo systemctl enable docker

# Adiciona o usuário padrão da AMI (ex: ubuntu) ao grupo Docker
# Use o usuário correto da sua AMI se não for 'ubuntu'
sudo groupadd docker || true
sudo usermod -aG docker ubuntu

# Tempo de iniciacao para o Docker
sleep 10

# Script para a criação e rodar o backend

sudo cat > /home/ubuntu/run_backend.sh <<EOF
#!/bin/bash

echo "Executando o script para rodar o backend de maneira manuallll"

export RDS_HOST="${rds_host}"
export RDS_PORT="${rds_port}"
export RDS_DATABASE="${rds_database}"
export RDS_USER="${rds_user}"
export RDS_PASSWORD="${rds_password}"

PRIVATE_DOCKER_IMAGE="${private_docker_image}"
CONTAINER_NAME="${container_name}" 
APP_PORT_HOST="${app_port_host}"
APP_PORT_CONTAINER="${app_port_container}"

echo "Configurando variaveis de ambiente para o container..."

echo "puxando a imagem Docker"

docker pull ${private_docker_image}

# Verifica o codigo de saida do pull
if [ $? -ne 0 ]; then echo "!!! ERRO pull !!!"; exit 1; fi

echo "Tentando parar e/ou remover o container existente"

docker stop ${container_name} > /dev/null 2>&1 || true # || true
docker rm ${container_name} > /dev/null 2>&1 || true

echo "Container limpo e pronto para rodar"

echo "Rodando o container do backend com o banco"

docker run -d --name ${container_name} -p ${app_port_host}:${app_port_container} \
  -e RDS_HOST="${rds_host}" \
  -e RDS_PORT="${rds_port}" \
  -e RDS_DATABASE="${rds_database}" \
  -e RDS_USER="${rds_user}" \
  -e RDS_PASSWORD="${rds_password}" \
  "${private_docker_image}" \

# verifica o codigo de saida do run
if [ $? -eq 0 ]; then echo "Docker run executado."; else echo "!!! ERRO run !!!"; exit 1; fi

# --- FIM DO CONTEÚDO DO ARQUIVO run_backend.sh ---
EOF

sudo chmod +x /home/ubuntu/run_backend.sh
sudo chown ubuntu:ubuntu /home/ubuntu/run_backend.sh

echo "Script manual do backend configurado e pronto para ser executado em /home/ubuntu/"