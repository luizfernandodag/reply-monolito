#!/bin/bash

# Verifica se o nome do módulo foi fornecido
if [ -z "$1" ]; then
  echo "Uso: $0 <nome_do_modulo>"
  exit 1
fi

MODULO_NAME=$1
MODULES_DIR="modules"
GROUP_ID="com.seuprojeto"
ARTIFACT_ID="projeto-monolito-$MODULO_NAME"
VERSION="1.0-SNAPSHOT"

# Cria a estrutura de pastas do Maven para o novo módulo
mkdir -p "$MODULES_DIR/$MODULO_NAME/src/main/java"
mkdir -p "$MODULES_DIR/$MODULO_NAME/src/main/resources"
mkdir -p "$MODULES_DIR/$MODULO_NAME/src/test/java"

# Cria o conteúdo do pom.xml para o módulo filho
cat <<EOF > "$MODULES_DIR/$MODULO_NAME/pom.xml"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>$GROUP_ID</groupId>
        <artifactId>projeto-monolito</artifactId>
        <version>$VERSION</version>
    </parent>

    <artifactId>$ARTIFACT_ID</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <!-- Adicionar dependências comuns aqui (ex: JAX-RS, JPA, etc.) -->
    </dependencies>
</project>
EOF

echo "Estrutura do módulo '$MODULO_NAME' e seu pom.xml criados com sucesso."
