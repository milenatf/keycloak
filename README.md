# Instalação e configurações iniciais do keycloak

- [Documentação oficial do keycloak](https://www.keycloak.org/documentation.html)
- [Github do keycloak](https://github.com/keycloak/keycloak?tab=readme-ov-file)

Este documento tem como objetivo levantar o keycloak em ambiente de desenvolvimento com o mysql

## Requisitos básicos
- Docker
- Docker Compose
- Mysql: versão 8.0.40
- keycloak: versão 26.0.7

## Start
Com os arquivos docker-compose.yml e Dockerfile na raiz do projeto, executar os comandos abaixo:

Acessar o diretório raiz do projeto e construir as imagens dos serviços (Keycloak e mysql) e iniciar os containers, "prendendo" o terminal
```sh
cd /diretorio/do/projeto/keycloak
docker compose up --build
```
⚠️ Este processo pode demorar bastante dependendo da conexão com a internet e capacidade da máquina ⚠️

Caso a mensage abaixo seja exibida no log do container do banco de dados, significa que o container do mysql está rodando corretamente.

> mysql_keycloak  | 2025-01-08T12:07:11.372625Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Bind-address: '::' port: 33060, socket: /var/run/mysqld/mysqlx.sock
mysql_keycloak  | 2025-01-08T12:07:11.372801Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.32'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.

Iniciar o container do keycloak.
```sh
docker start <container_name_or_id>
```

⚠️ Este processo pode demorar bastante dependendo da conexão com a internet e capacidade da máquina ⚠️

```sh
docker start <id_ou_nome_do_container_do_keycloak>
```

A mensagem abaixo deve ser exibida no arquivo de logs. Isso significa que o container do keycloak foi executado corretamente e está rodando:

> keycloak        | 2025-01-08 12:43:36,882 WARN  [org.keycloak.quarkus.runtime.KeycloakMain] (main) Running the server in development mode. DO NOT use this configuration in production.

Acessar o keycloak local na porta, do host local, definida no container do keycloak
```sh
http://localhost:8000/admin
```

## Possíveis problemas:

- Comunicação com o banco de dados
- Permissões do usuário

### Configurações no banco de dados mysql

Para executar os comandos abaixo é necessário informar os valores das variáveis de ambiente definidas no docker-compose.yml do container do mysql. São elas:

- MYSQL_ROOT_PASSWORD: password
- MYSQL_PASSWORD: password
- MYSQL_USER: keycloak
- IP do container do mysql (Verificar tópico: Comandos úteis)

Acessar o container do banco de dados
```sh
docker compose exec <container> bash
```

Dentro do container acessar o terminal do mysql com usuário root com senha definida na variável de ambiente MYSQL_ROOT_PASSWORD
```sh
mysql -u root -p
```

Executar os seguintes comandos no mysql:

Verificar se a base de dados foi criada
```sql
show databases;
```

Criar o usuario com o host específico

```sql
CREATE USER 'MYSQL_USER'@'<ip_do_container_mysql>' IDENTIFIED BY 'MYSQL_PASSWORD';
```

Dar privilégios ao usuário definido na variável de ambiente MYSQL_USER do container do banco de dados
```sql
GRANT ALL PRIVILEGES ON *.* TO 'MYSQL_USER'@'<ip_do_container_mysql>';
FLUSH PRIVILEGES;
```

Verificar se o usuario foi criado
```sql
SELECT user, host from mysql.user;
```

Reiniciar o container do mysql e do keycloak, nesta ordem.

## Comandos úteis para o docker

Listar todos os containers
```sh
docker ps -a
```

Para acessar o log do container em tempo real
```sh
docker logs -f <container_name_or_id>
```

Iniciar um container
```sh
docker start <container_name_or_id>
```

Reiniciar um container
```sh
docker restart <container_name_or_id>
```

Verificar o IP de um container
```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <id_do_container>
```

