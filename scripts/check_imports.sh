#!/bin/bash
# scripts/check_imports.sh

echo "🔍 Iniciando verificação de Governança de Arquitetura (ADR 003)..."

# Allowlist de packages permitidos dentro de app/lib/
ALLOWED="package:flutter/|package:dart:|package:shared/|package:design_system/|package:caveo_challenge/"

# Busca imports em app/lib/ que não estejam na allowlist
VIOLATIONS=$(grep -r "import 'package:" app/lib/ 2>/dev/null | grep -vE "$ALLOWED" || true)

if [ -n "$VIOLATIONS" ]; then
    echo "❌ VIOLAÇÃO DE ARQUITETURA DETECTADA!"
    echo "======================================="
    echo "Os seguintes arquivos importam pacotes externos diretamente, violando a ADR 003:"
    echo ""
    echo "$VIOLATIONS"
    echo ""
    echo "---------------------------------------"
    echo "Regra: Todo pacote externo deve ser encapsulado em 'packages/shared/lib/libraries/'."
    echo "Exceção: Packages na Allowlist (flutter, shared, design_system, caveo_challenge)."
    echo "Ação: Mova o import para um arquivo _export.dart em packages/shared/lib/libraries/ e importe-o de lá."
    echo "======================================="
    exit 1
else
    echo "✅ Nenhum import proibido encontrado."
fi
