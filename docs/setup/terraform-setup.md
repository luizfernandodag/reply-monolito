# Configuração do Terraform

Este guia detalha os passos para configurar o ambiente de desenvolvimento para trabalhar com Terraform.

## 1. Instalação do Terraform CLI

A maneira mais fácil de instalar o Terraform é usando o gerenciador de pacotes apropriado para o seu sistema operacional.

**macOS (via Homebrew)**
```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform


**Linux, WSL (via Snap)**
```sh
sudo snap install terraform --classic
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform --version

```