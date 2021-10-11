# Introdução

Esse código provisiona toda a infraestrutura necessária para execução desse exemplo do cluster do RabbitMW.
 

# Workspaces

O código criado utiliza o conceito de workspaces, incialmente foi pensado a utilização de três workspaces para separar os recursos dos ambientes de desenvolvimento homologação e produção, é importante observar esse ponto na criação dos códigos e na aplicação da infraestrutura.

## Para verificar os workspaces existentes

```bash
terraform workspace list
```

## Para selecionar um workspace
```bash
terraform workspace select <workspace name>
```

## Para verificar o workspace em uso atualmente
```bash
terraform workspace show
```

# Para verificar as alterações que serão realizadas

```bash
terraform plan -var-file=$(terraform workspace show).tfvars
```

# Para aplicar as alterações na infra estrutura
```bash
terraform apply -var-file=$(terraform workspace show).tfvars
```