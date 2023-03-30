#!/bin/bash

if systemctl is-active httpd.service > /dev/null; then
    status="OK"
    message="Serviço do Apache: ONLINE"
else
    status="ERROR"
    message="Serviço do Apache: OFFLINE"
fi

filename=$(date +"%d-%m-%Y_%H:%M")_${status}_${message// /_}.txt

filepath=/efs/marco/logs.apache/$filename

echo "Data e Hora: $(LC_TIME=pt_BR.UTF-8 date -d now '+%A, %d de %B de %Y - %H:%M:%S')" >> $filepath
echo "Nome do Serviço: Apache" >> $filepath
echo "Status: $status" >> $filepath
echo "Mensagem: $message" >> $filepath

