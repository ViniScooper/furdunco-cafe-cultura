#!/bin/sh
set -e

echo "🚀 [Furdunço API] Verificando e rodando migrações automáticas..."
node migrar-banco-completo.js || true
node migrar-ajustes-sivirino.js || true
node migrar-engenharia.js || true
node migrar-selos.js || true
node migrar-delivery.js || true
# Seed do cardapio NAO roda no boot (prato nao tem chave unica e duplicaria itens). Use: npm run seed (so em banco vazio).

echo "✅ [Furdunço API] Migrações e cardápio prontos! Iniciando servidor..."
exec node server.js
