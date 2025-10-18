# Módulos Terraform

Este diretório contém a infraestrutura como código (IaC) do projeto, gerenciada com Terraform. A infraestrutura está separada por ambientes (`dev`, `prd`), seguindo a estrutura de diretórios recomendada.

## Pré-requisitos

Antes de executar o Terraform, certifique-se de ter o seguinte instalado:

*   **Terraform CLI**: Verifique a versão com `terraform version`.
*   **Credenciais do provedor de nuvem**: Assegure-se de que as credenciais para o provedor de nuvem (ex.: AWS, GCP, Azure) estejam configuradas e acessíveis localmente ou no ambiente de CI/CD.

## Como executar

Siga estes passos para provisionar ou atualizar a infraestrutura:

1.  **Navegue até o ambiente desejado**.
    ```sh
    cd infra/terraform/environments/<ambiente>
    ```
    Substitua `<ambiente>` por `dev` ou `prd`.

2.  **Inicialize o Terraform**.
    Este comando baixa os provedores e módulos necessários.
    ```sh
    terraform init
    ```

3.  **Planeje a execução**.
    Visualize as mudanças que serão aplicadas na infraestrutura sem executá-las.
    ```sh
    terraform plan
    ```

4.  **Aplique as mudanças**.
    Use este comando para aplicar as alterações na infraestrutura. Você será solicitado a confirmar.
    ```sh
    terraform apply
    ```
    Para pular a confirmação manual, use a flag `-auto-approve`.
    ```sh
    terraform apply -auto-approve
    ```

5.  **Destrua a infraestrutura (opcional)**.
    Para remover todos os recursos gerenciados pelo Terraform neste ambiente. **Use com cautela!**
    ```sh
    terraform destroy
    ```

## Observações

*   Para mais detalhes sobre a configuração específica de cada ambiente, consulte os arquivos `.tf` dentro dos respectivos diretórios.
*   Em ambientes de produção, é altamente recomendável utilizar um backend remoto (como S3, GCS ou Azure Blob Storage) para o estado do Terraform, a fim de garantir a consistência e o trabalho em equipe.
