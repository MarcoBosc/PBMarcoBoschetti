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

echo "Data e Hora: $(date)" >> $filepath
echo "Nome do Serviço: Apache" >> $filepath
echo "Status: $status" >> $filepath
echo "Mensagem: $message" >> $filepath

