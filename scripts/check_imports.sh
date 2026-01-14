#!/bin/bash
# scripts/check_imports.sh

echo "🔍 Iniciando verificação de Governança de Arquitetura (ADR 003)..."

# package:app is the project itself
ALLOWED="package:flutter/|package:dart:|package:app/|package:design_system/"

VIOLATIONS=$(grep -r "import 'package:" lib/ 2>/dev/null | grep -v "lib/shared/libraries/" | grep -vE "$ALLOWED" || true)

if [ -n "$VIOLATIONS" ]; then
    echo "❌ VIOLAÇÃO DE ARQUITETURA DETECTADA!"
    echo "======================================="
    echo "Os seguintes arquivos importam pacotes externos diretamente, violando a ADR 003:"
    echo ""
    echo "$VIOLATIONS"
    echo ""
    echo "---------------------------------------"
    echo "Regra: Todo pacote externo deve ser encapsulado em 'lib/shared/libraries/'."
    echo "Exceção: Packages na Allowlist (flutter, app, design_system)."
    echo "Ação: Mova o import para um arquivo _export.dart em shared/libraries e importe-o de lá."
    echo "======================================="
    exit 1
else
    echo "✅ Nenhum import proibido encontrado."
fi
