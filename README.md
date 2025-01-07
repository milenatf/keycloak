# Instalação e configurações iniciais do keycloak

[Documentação oficial do keycloak](https://www.keycloak.org/documentation.html)
[Github do keycloak](https://github.com/keycloak/keycloak?tab=readme-ov-file)

Este documento tem como objetivo levantar o keycloak em ambiente de desenvolvimento com o mysql

## Requisitos básicos
- Docker
- Docker Compose
- Mysql: versão 8.0
- keycloak: versão 26.0.7

## Start
Com os arquivos docker-compose.yml e Dockerfile na raiz do projeto, executar os comandos abaixo:

Acessar o diretório raiz do projeto e construir as imagens dos serviços (Keycloak e mysql) e iniciar os containers, "prendendo" o terminal
```sh
cd /diretorio/do/projeto/keycloak
docker compose up --build
```
⚠️ Este processo pode demorar bastante dependendo da conexão com a internet e capacidade da máquina ⚠️

Se, nos logs do container do mysql exibir a informação abaixo, quer dizer que o processo está sendo executado corretamente para o banco de dados

Para acessar o log do container em tempo real, caso o build tenha sido executado como -d
```sh
docker logs -f <container_name_or_id>
```

## Configurações no banco de dados mysql

Acessar o container do banco de dados
```sh
docker compose exec <container> bash
```

Dentro do container acessar o terminal do mysql com usuário root e a senha definida na variável de ambiente MYSQL_ROOT_PASSWORD definida no container do banco de dados no docker-compose.yml

```sh
mysql -u root -p
```

Executar os seguintes comandos no mysql:

Verificar se a base de dados foi criada
```sql
show databases;
```

Criar o usuario definido na variável de ambiente MYSQL_USER com a senha definida na variável de ambiente MYSQL_PASSWORD  do container mysql para o host que é exibido no log do container do keycloak
```sql
CREATE USER 'MYSQL_USER'@'127.18.0.3' IDENTIFIED BY 'MYSQL_PASSWORD';
```

Dar privilégios ao usuário definido na variável de ambiente MYSQL_USER do container do banco de dados
```sql
GRANT ALL PRIVILEGES ON *.* TO 'MYSQL_USER'@'127.18.0.3';
FLUSH PRIVILEGES;
```

Verificar se o usuario foi criado
```sql
SELECT user, host from mysql.user;
```

Reiniciar o container do mysql e do keycloak, nesta ordem.

Acessar o keycloak local na porta, do host local, definida no container do keycloak
```sh
http://localhost:8000/admin
```