#!/bin/bash

log_dir="/caminho/para/diretorio/de/logs"
max_logs=1000

num_logs=$(ls -1 "$log_dir" | wc -l)

if [ $num_logs -gt $max_logs ]; then
  logs_to_delete=$((num_logs - max_logs + 200))
  if [ $logs_to_delete -gt 0 ]; then
    cd "$log_dir" || exit
    ls -t | tail -$logs_to_delete | xargs rm --
    echo "Excluídos $logs_to_delete logs antigos."
  fi
fi
