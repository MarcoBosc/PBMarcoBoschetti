# Configurando instância o servidor.
Passo a passo para a confuguração do servidor.
> Crie um _EFS_ no console da Amazon AWS na parte de EFS;

> Crie um _Security Group_ liberando as portas de comunicação (22/TCP 111/TCP, 2049/TCP/UDP, 80/TCP e 443/TCP);

> Crie uma _Instância_ EC2 do tipo _t3.micro_ com 16 GB SSD e atrele o EFS criado anteriormente;
Lembre-se de adicionar o script para baixar e ativar o apache no user data (O script está no final do arquivo READ.ME).

> Crie um _elástic ip_ no console da AWS e atrele com a instância criada anteriormente;

> Acesse a instância via SSH através do seu terminal;

> Digite o comando _sudo su -_ para acessar como o usuário admnistrador;

> Digite o comando _cd /_ para acessar o diretório raiz do servidor;

> Crie um diretório chamado efs com o comando _mkdir efs_ e acesse-o através do comando _cd efs_, então use o comando para montar o EFS no diretório;
Você pode ter acesso ao comando através do console da amazon, na parte de file systems onde está o seu efs criado, clique em attach e copie o comando disponibilizado pela AWS.

> Crie um diretório com seu nome com o camando _mkdir seu_nome_ e acesse o diretório;

> Você pode clonar o repositório ou criar o script para gerar as logs do apache manualmente (lembre de salvar o script como .sh);
O script será disponibilizado ao final do READ.ME.

> Crie um diretório chamado apache.logs com o comando _mkdir apache.logs_

> Digite o comando crontab -e;

> Adicione a seguinte linha ao final do arquivo _*/5 * * * * /caminho/do/seu/script.sh_;


# Script para colocar no userdata da instância.

> #!/bin/bash
> 
> yum update -y
> 
> yum install httpd -y
> 
> systemctl enable httpd && systemctl start httd

# Script em bash para criar as logs do apache.
> !/bin/bash

> Verifica se o Apache está online
> 
> if systemctl is-active httpd.service > /dev/null; then
> 
>     status="online"
>     
>     message="O serviço Apache está online."
>     
> else
> 
>     status="offline"
>     
>     message="O serviço Apache está offline."
>     
> fi
>
> Cria o nome do arquivo com a data e hora atual
> 
> filename=$(date +"%d-%m-%Y_%H:%M")_${status}_${message// /_}.txt

> Cria o conteúdo do arquivo
> 
> echo "Data e Hora: $(date)" >> /efs/seu_nome/apache.logs/$filename
> 
> echo "Nome do Serviço: Apache" >> /efs/seu_nome/apache.logs/$filename
> 
> echo "Status: $status" >> /efs/seu_nome/apache.logs/$filename
> 
> echo "Mensagem: $message" >> /efs/seu_nome/apache.logs/$filename
