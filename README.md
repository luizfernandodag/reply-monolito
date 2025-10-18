# 🧩 Projeto — Fase 0: Pré-requisitos e Ambiente de Desenvolvimento

Este documento descreve a configuração inicial do ambiente de desenvolvimento para o projeto de **desacoplamento do monólito Java 8 em microserviços**, com stack moderna (Java/Kotlin/Go, Docker, Terraform, EKS, etc).

---

## 🚀 Objetivo

- Garantir ambiente local padronizado (Java 8, Maven, Docker, Postgres)
- Estruturar repositório Git (branches `main`, `develop`, `feature/*`)
- Subir banco de dados local via Docker Compose com persistência
- Validar build e execução do monólito
- Preparar diretórios para infraestrutura (Terraform / Kubernetes)

---

## 🧱 Estrutura de Diretórios

```
project-root/
├─ monolith/                # Código Java (Maven)
│  ├─ pom.xml
│  └─ src/
├─ infra/
│  ├─ terraform/            # Configurações Terraform (EKS, rede, etc)
│  └─ k8s/                  # Manifests Kubernetes
├─ docker/
│  ├─ docker-compose.yml    # Banco Postgres local
│  └─ initdb/               # Scripts SQL de inicialização (opcional)
├─ scripts/                 # Automação local
│  ├─ start-local.sh
│  └─ stop-local.sh
├─ docs/
└─ .gitignore
```

---

## 💻 Ambiente de Desenvolvimento (Windows + WSL2 Recomendado)

### 1. Instalar WSL2 e Ubuntu
Abra o PowerShell (admin):
```powershell
wsl --install -d Ubuntu
```
Depois reinicie o PC.

### 2. Configurar Ubuntu no WSL
No terminal Ubuntu:
```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Instalar dependências principais
```bash
sudo apt install -y openjdk-8-jdk maven docker-compose nodejs npm unzip
```

### 4. Instalar ferramentas de infraestrutura
```bash
# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Terraform
curl -LO https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin
```

### 5. Configurar Docker Desktop (no Windows)
- Instale [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Vá em **Settings → Resources → WSL Integration**
- Ative sua distro Ubuntu.

Teste:
```bash
docker info
```

### 6. Clonar projeto dentro do WSL
⚠️ **Não clone em `/mnt/c/...`** (NTFS é lento e incompatível).  
Use:
```bash
cd ~
mkdir projects && cd projects
git clone <repo-url>
```

---

## 🐘 Banco de Dados Local (Postgres via Docker)

Arquivo: `docker/docker-compose.yml`
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:13
    container_name: project_postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: projectdb
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./initdb:/docker-entrypoint-initdb.d
    ports:
      - "5432:5432"

volumes:
  pgdata:
```

Iniciar:
```bash
cd docker
docker-compose up -d
```

Verificar:
```bash
docker ps
docker logs -f project_postgres
```

Acessar banco:
```bash
docker exec -it project_postgres psql -U devuser -d projectdb
```

---

## 🧰 Repositório Git

```bash
cd project-root
git init
git checkout -b main
echo "target/" > .gitignore
echo ".env" >> .gitignore
git add .
git commit -m "chore: initial commit - project structure"

git checkout -b develop
git push -u origin main develop
```

Fluxo de branches:
- `main` → produção  
- `develop` → ambiente de dev  
- `feature/*` → desenvolvimento de novas funcionalidades  

---

## 🧪 Build e Execução Local (Monólito)

```bash
cd monolith
mvn clean package -DskipTests
java -jar target/your-app.jar --spring.profiles.active=dev
```

Verifique no navegador:  
👉 http://localhost:8080

---

## ⚙️ Configuração de Banco (Spring Boot example)

Arquivo: `src/main/resources/application-dev.properties`
```
spring.datasource.url=jdbc:postgresql://localhost:5432/projectdb
spring.datasource.username=devuser
spring.datasource.password=devpass
spring.jpa.hibernate.ddl-auto=update
```

---

## 🧩 Scripts Locais

### `scripts/start-local.sh`
```bash
#!/usr/bin/env bash
set -e
echo "🚀 Starting local Postgres..."
docker-compose -f docker/docker-compose.yml up -d
echo "🔨 Building monolith..."
cd monolith
mvn clean package -DskipTests
echo "✅ Running application..."
java -jar target/your-app.jar --spring.profiles.active=dev &
```

### `scripts/stop-local.sh`
```bash
#!/usr/bin/env bash
set -e
echo "🛑 Stopping services..."
docker-compose -f docker/docker-compose.yml down
pkill -f your-app.jar || true
echo "✅ All services stopped."
```

Dar permissão:
```bash
chmod +x scripts/*.sh
```

---

## 🧭 Infraestrutura — Terraform & Kubernetes (Preparação)

### Terraform
```bash
cd infra/terraform
terraform init
terraform fmt
terraform validate
```

### EKS Cluster (opcional)
```bash
eksctl create cluster   --name dev-cluster   --region us-east-1   --nodes 2   --node-type t3.medium
```

Verificar:
```bash
kubectl get nodes
```

---

## ✅ Checklist Final

| Item | Status |
|------|---------|
| Java 8 e Maven instalados (`java -version`, `mvn -v`) | ✅ |
| Docker + docker-compose funcionando | ✅ |
| Postgres rodando em `localhost:5432` | ✅ |
| Git inicializado com `main` e `develop` | ✅ |
| Scripts `start-local.sh` e `stop-local.sh` funcionando | ✅ |
| Estrutura `infra/` pronta e `terraform init` executado | ✅ |
| kubectl e eksctl configurados | ✅ |
| README atualizado | ✅ |

---

## 🧾 Próximos Passos (Fase 1)

- Definir módulos/domínios do monólito a serem **estrangulados** (Strangler Pattern)
- Implementar **CDC/Dual-write** entre o monólito e microserviços
- Criar **primeiro microserviço (domain X)** com build independente
- Integrar métricas e observabilidade (OTel padrão)

---

## 👨‍💻 Autor

**Luiz Gadêlha**  
Senior Backend & Cloud Engineer  
Stack: Java, Kotlin, Python, Node.js, AWS, Terraform, EKS  
📧 Contato: [seu-email]  
🔗 GitHub: [seu-usuario]
