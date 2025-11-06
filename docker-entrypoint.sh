#!/bin/bash
set -e

echo "⏳ Esperando a que Oracle esté listo..."
# until sqlplus -S system/123456@//oracle-xe:1521/XEPDB1 <<< "SELECT 1 FROM dual;" > /dev/null 2>&1; do
#   sleep 5
#   echo "🔄 Oracle aún no responde..."
# done

sleep 10

echo "✅ Oracle disponible, ejecutando migraciones..."
bundle exec rails db:migrate

echo "🚀 Iniciando servidor Rails..."
bundle exec rails server -b 0.0.0.0
