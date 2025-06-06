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

sleep 10


PUBLIC_DOCKER_IMAGE="${public_docker_image}"
BACKEND_SERVERS="${backend_servers}"

echo "Puxando a imagem Docker do frontend: ${public_docker_image}" 
sudo docker pull "${public_docker_image}" 

if [ $? -ne 0 ]; then
  echo "Erro ao puxar a imagem do docker hub: ${public_docker_image}" 
  exit 1
fi

echo "Removendo o container frontend se já existir"

sudo docker stop "archfacts-frontend" > /dev/null 2>&1 || true
sudo docker rm "archfacts-frontend" > /dev/null 2>&1 || true

echo "conteúdo do backend_servers: ${backend_servers}"

echo "Rodando o container frontend com as variaveis de ambiente" 

sudo docker run -d \
  --name "archfacts-frontend" \
  -p 80:80 \
  -e BACKEND_SERVERS="${backend_servers}" \
  "${public_docker_image}"

if [ $? -eq 0 ]; then
  echo "Container frontend rodando com sucesso."
else
  echo "Erro ao rodar o container frontend"
  exit 1
fi