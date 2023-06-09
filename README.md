# Configurando o servidor.
Passo a passo para a confuguração do servidor.
> Crie um _EFS_ no console da Amazon AWS na parte de EFS;

> Crie um _Security Group_ liberando as portas de comunicação (22/TCP 111/TCP, 2049/TCP/UDP, 80/TCP e 443/TCP);

> Crie uma _Instância_ EC2 do tipo _t3.micro_ com 16 GB SSD e atrele o EFS criado anteriormente;
Lembre-se de adicionar o script para baixar e ativar o apache no user data (O script está no final do arquivo READ.ME).

> Crie um _elástic ip_ no console da AWS e atrele com a instância criada anteriormente;

> Acesse a instância via SSH através do seu terminal;

> Digite o comando ```sudo su -``` para acessar como o usuário admnistrador;

> Digite o comando ```cd /``` para acessar o diretório raiz do servidor;

> Crie um diretório chamado efs com o comando ```_mkdir efs_``` e acesse-o através do comando ```cd efs```, então use o comando para montar o EFS no diretório;
Você pode ter acesso ao comando através do console da amazon, na parte de file systems onde está o seu efs criado, clique em attach e copie o comando disponibilizado pela AWS.

> Digite o comando _cd/etc_ e _nano fstab_ para alterar o arquivo de inicialização e cole o comando para montar seu efs na inicialização da instância;
Exemplo de comando para montar o efs na inicialização <IP do DNS do EFS>:/ /mnt/efs nfs4     nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0

Você pode tirar suas dúvidas sobre o processo de montagem automacessando o link https://docs.aws.amazon.com/pt_br/efs/latest/ug/mount-fs-auto-mount-onreboot.html

> Onde você montou o efs, crie um diretório com seu nome com o camando ```mkdir seu_nome``` e acesse-o;

> Você pode clonar o repositório ou criar o script para gerar as logs do apache e excluir logs antigas manualmente (lembre de salvar o script como .sh);
Os scripts serão disponibilizados ao final do READ.ME.

> Crie um diretório chamado apache.logs com o comando ```mkdir apache.logs```

> Digite o comando ```crontab -e```;

> Adicione a seguinte linha ao final do arquivo ```*/5 * * * * /caminho/do/seu/script.sh```;
> Adicione outra linha ao final do arquivo ```0 0 */5 * * /caminho/do/script/de/excluir/logs.sh```;
> Aperte a tecla "esc" seguido de ":wq" e enter para salvar as alterações do arquivo e sair.

> Digite o comando ```sudo yum install -y mod_ssl``` para configurar o HTTPS e abrir a porta 443, vá para ```cd /etc/httpd``` e crie um diretório chamado 
> ssl e rode o comando ```openssl req -x509 -newkey rsa:4096 -keyout apache.key -out apache.crt -days 365 -nodes``` para gerar as chaves SSL;

> Rode o comando ```systemctl restart httpd```;

> Se necessário comente a linha ```SSLCertificateKeyFile /etc/pki/tls/private/localhost.key``` dentro da pasta ssl.conf no diretório /etc/httpd/httpd.conf e tente reiniciar o serviço hpptd novamente;
Em caso de dúvidas aqui está o link para a configurção do SSL em instâncias ec2: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-amazon-linux-2.html

# Script para adicionar no userdata da instância.
```bash
     #!/bin/bash
    
     yum update -y
    
     yum install httpd -y
    
     systemctl enable httpd && systemctl start httd
```  

# Script em bash para criar as logs do apache.
```bash
   !/bin/bash
   
   if systemctl is-active httpd.service > /dev/null; then
   
       status="OK"
       message="Serviço do Apache: ONLINE"
  
   else
    
       status="ERROR"
       message="Serviço do Apache: OFFLINE"
       
   fi
  
   
   filename=$(date +"%d-%m-%Y_%H:%M")_${status}_${message// /_}.txt
  
   
   echo "$(LC_TIME=pt_BR.UTF-8 date -d now '+%A, %d de %B de %Y - %H:%M:%S')" >> /efs/seu_nome/apache.logs/$filename
   
   echo "Apache status:" >> /efs/seu_nome/apache.logs/$filename
   
   echo "Status: $status" >> /efs/seu_nome/apache.logs/$filename
   
   echo "Mensagem: $message" >> /efs/seu_nome/apache.logs/$filename
   
 ``` 

# Script em bash para limpar logs antigas.
```bash
    !/bin/bash
   
    log_dir="/caminho/para/diretorio/de/logs"
    
    max_logs=1000
   
    num_logs=$(ls -1 "$log_dir" | wc -l)
    
    deleted_logs=300
    
    if [ $num_logs -gt $max_logs ]; then
   
      logs_to_delete=$((num_logs - max_logs + 300))
      
      if [ $logs_to_delete -gt 0 ]; then
      
        cd "$log_dir" || exit
        
        ls -t | tail -$logs_to_delete | xargs rm --
        
        echo "Excluídos $logs_to_delete logs antigos."
        
      fi
      
    fi
```
