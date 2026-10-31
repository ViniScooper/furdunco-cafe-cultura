#!/bin/sh
set -e

echo "🚀 [Furdunço API] Verificando e rodando migrações automáticas..."
node migrar-banco-completo.js || true
node migrar-ajustes-sivirino.js || true
node migrar-engenharia.js || true
node migrar-selos.js || true
node migrar-delivery.js || true
node seed-furdunco.js || true

echo "✅ [Furdunço API] Migrações e cardápio prontos! Iniciando servidor..."
exec node server.js
