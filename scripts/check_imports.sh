#!/bin/bash
# scripts/check_imports.sh
#
# Architecture Governance Script (ADR 003)
# Validates that packages only import from their allowed dependencies.
#
# Usage:
#   ./scripts/check_imports.sh           # Check all packages
#   ./scripts/check_imports.sh app       # Check only app
#   ./scripts/check_imports.sh shared    # Check only shared
#   ./scripts/check_imports.sh dori      # Check only dori

set -e

# ============================================================================
# ALLOWLISTS PER PACKAGE (ADR 003)
# ============================================================================
# Each package has its own allowlist of permitted external imports.
# Packages not in the allowlist must be consumed via shared/libraries/*_export.dart

# App: Can only import Flutter SDK + internal packages (shared, dori)
ALLOWLIST_APP="package:flutter/|package:dart:|package:shared/|package:dori/|package:caveo_challenge/"

# Shared: Can import Flutter SDK + its declared dependencies (for implementations)
# Note: External libs should only be used in src/ (private) or libraries/ (exports)
ALLOWLIST_SHARED="package:flutter/|package:dart:|package:shared/|package:shared_preferences/|package:connectivity_plus/|package:mocktail/|package:dio/|package:flutter_dotenv/|package:equatable/|package:flutter_riverpod/|package:riverpod/|package:go_router/"

# Dori: Flutter SDK + its declared dependencies (Design System package)
# Dori is independent and can have its own dependencies for UI rendering
ALLOWLIST_DORI="package:flutter/|package:dart:|package:dori/|package:flutter_svg/"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_header() {
    echo ""
    echo "🔍 ========================================"
    echo "   Architecture Governance Check (ADR 003)"
    echo "   ========================================"
    echo ""
}

print_violation() {
    local package=$1
    local violations=$2
    
    echo "❌ VIOLATION DETECTED in $package"
    echo "───────────────────────────────────────────"
    echo "$violations"
    echo "───────────────────────────────────────────"
    echo ""
}

print_success() {
    local package=$1
    echo "✅ $package: No prohibited imports found"
}

print_summary_violation() {
    echo ""
    echo "========================================"
    echo "❌ ARCHITECTURE VIOLATIONS DETECTED!"
    echo "========================================"
    echo ""
    echo "Rule: External packages must be consumed via shared/libraries/*_export.dart"
    echo "Action: Move the import to an _export.dart file in packages/shared/lib/libraries/"
    echo ""
    echo "Allowlists by package:"
    echo "  • app: flutter, dart, shared, dori, caveo_challenge"
    echo "  • shared: flutter, dart, shared, + declared dependencies"
    echo "  • dori: flutter, dart, dori (pure UI, no external deps)"
    echo ""
}

check_package() {
    local name=$1
    local path=$2
    local allowlist=$3
    local has_violation=0
    
    if [ ! -d "$path" ]; then
        echo "⚠️  $name: Directory not found at $path (skipping)"
        return 0
    fi
    
    # Find violations: imports starting with 'package:' not in allowlist
    local violations
    violations=$(grep -r "import 'package:" "$path" 2>/dev/null | grep -vE "$allowlist" || true)
    
    if [ -n "$violations" ]; then
        print_violation "$name" "$violations"
        return 1
    else
        print_success "$name"
        return 0
    fi
}

# ============================================================================
# MAIN
# ============================================================================

print_header

TARGET=${1:-all}
TOTAL_VIOLATIONS=0

case $TARGET in
    app)
        check_package "app" "app/lib" "$ALLOWLIST_APP" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        ;;
    shared)
        check_package "shared" "packages/shared/lib" "$ALLOWLIST_SHARED" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        ;;
    dori)
        check_package "dori" "packages/dori/lib" "$ALLOWLIST_DORI" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        ;;
    all)
        check_package "app" "app/lib" "$ALLOWLIST_APP" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        check_package "shared" "packages/shared/lib" "$ALLOWLIST_SHARED" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        check_package "dori" "packages/dori/lib" "$ALLOWLIST_DORI" || TOTAL_VIOLATIONS=$((TOTAL_VIOLATIONS + 1))
        ;;
    *)
        echo "❌ Unknown target: $TARGET"
        echo "Usage: $0 [app|shared|dori|all]"
        exit 1
        ;;
esac

echo ""

if [ $TOTAL_VIOLATIONS -gt 0 ]; then
    print_summary_violation
    exit 1
else
    echo "========================================"
    echo "✅ All packages passed governance check!"
    echo "========================================"
fi
