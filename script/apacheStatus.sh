#!/bin/bash

# Verifica se o Apache está online
if systemctl is-active httpd.service > /dev/null; then
    status="online"
    message="O serviço Apache está online."
else
    status="offline"
    message="O serviço Apache está offline."
fi

# Cria o nome do arquivo com a data e hora atual
filename=$(date +"%d-%m-%Y_%H:%M")_${status}_${message// /_}.txt

# Cria o caminho completo para o arquivo de log
filepath=/marco/logs.apache/$filename

# Cria o conteúdo do arquivo
echo "Data e Hora: $(date)" >> $filepath
echo "Nome do Serviço: Apache" >> $filepath
echo "Status: $status" >> $filepath
echo "Mensagem: $message" >> $filepath

