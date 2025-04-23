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