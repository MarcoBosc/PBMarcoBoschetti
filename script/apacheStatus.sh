#!/bin/bash

# Verifica se o Apache está online
if curl -s --head http://localhost | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null; then
    status="online"
    message="O serviço Apache está online."
else
    status="offline"
    message="O serviço Apache está offline."
fi

# Cria o nome do arquivo com a data e hora atual
filename=$(date +"%Y%m%d_%H%M%S")_${status}_${message// /_}.txt

# Cria o conteúdo do arquivo
echo "Data e Hora: $(date)" >> /marco/$filename
echo "Nome do Serviço: Apache" >> /marco/$filename
echo "Status: $status" >> /marco/$filename
echo "Mensagem: $message" >> /marco/$filename
