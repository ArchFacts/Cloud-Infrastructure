![Logo da ArchFacts](/archfacts/src/utils/assets/logo.svg)
# Cloud Infrastructure
## ArchFacts - Infra em Nuvem 

## Introdução
### ArchFacts é uma aplicação Web que proporciona uma interface intuitiva de um sistema de ERP para prestadores de serviço se organizarem com seus clientes e pessoalmente

## Descrição
O projeto é uma solução em nuvem para o projeto Archfacts rodando em nuvem. Utilizando Docker para a conteinerização das aplicações e o Terraform para o provisionamento da infraestrutura.

## Funcionalidades
* Terraform: Infraestrutura provisionada automaticamente utilizando IAC e com estrutura de módulos.
* Docker: O Docker rodará as aplicações front e back em containeres 
* Infraestrutura: Uma rede completa para rodar a aplicação. Serão criadas máquinas EC2 para rodar o Frontend e o Backend e para o banco o serviço RDS é utilizado;
* Rede: Para a segurança da rede é utilizada uma VPC, uma espécie de Firewall virtual, somados com Security Groups e NACL são serviços que garantem a segurança da aplicação com bloqueios personalizados. 
* Conexão: A máquina privada só tem acesso somente da máquina pública, sendo assim necessário um NAT GATEWAY e Route Tables para fazer o roteamento para o acesso da internet. Uma camada de segurança a mais
* Load Balancer: Utilizando o NGINX é feito um balanceamento de carga entre duas máquinas privadas que estão rodando o Backend.
// * Script Shell: Scripts shell fazem o trabalho de rodar a aplicação automaticamente quando ela é provisionada, menos no Backend, sendo necessário rodar manualmente por fins de segurança dos dados.
  
  ## Tecnologias Utilizadas
- AWS
- Terraform
- Docker

## Configurando o Ambiente de Desenvolvimento
### Requisitos
- Terraform instalado
- Conta na AWS
- AWS CLI
- Docker instalado

## Componentes necessários
1. A aplicação ArchFacts é modularizada em dois componentes principais, cada um com seu próprio repositório de código-fonte:

    Frontend:
        Tecnologias: React, Vite
        Repositório: https://github.com/ArchFacts/App-Web
        Descrição: Responsável pela interface do usuário e interação com a API do backend.

    Backend:
        Tecnologias: Java, Spring Boot
        Repositório: https://github.com/ArchFacts/Spring-Rest
        Descrição: Implementa a lógica de negócios, a API RESTful e a persistência de dados.

2. Dentro desses repositórios existem arquivos Docker, faça o build e dentro da sua conta do Dockerhub coloque o projeto e faça as alterações necessárias nos arquivos


## Instalação
1. Clone o repositório 
```
git clone https://github.com/ArchFacts/Cloud-Infrastructure.git
```

2. Mova-se para o diretório
```
Cloud-Infrastructure/infra
```

3. Verifique todas as variáveis e coloque-as de acordo com SUAS próprias informações
```
terraform.tfvars
```

4. Rode os comandos
```
Terraform Init
Terraform Plan
Terraform Apply
```

5. As máquinas serão criadas, basta fazer o Bastion Jump da máquina pública para a privada e rodar o Backend nela e depois conectar-se no ip da máquina pública:

OBS: Este tutorial tem conhecimentos mais avançados, devido a complexidade de alguns passos e também é necessário ter experiência nas ferramentas para resolver quaisquer eventualidades.
