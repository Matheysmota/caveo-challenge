#!/bin/bash
# ==============================================================================
# Development Run Script
# ==============================================================================
# Reads environment variables from .devEnv and runs Flutter with --dart-define
#
# Usage:
#   ./scripts/run_dev.sh [flutter_args...]
#
# Examples:
#   ./scripts/run_dev.sh                    # Run in debug mode
#   ./scripts/run_dev.sh -d chrome          # Run on Chrome
#   ./scripts/run_dev.sh build apk          # Build APK with dev config
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.devEnv"

# Check if .devEnv exists
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: .devEnv file not found at $ENV_FILE"
    echo "   Create one based on .devEnv.example"
    exit 1
fi

# Build --dart-define arguments from .devEnv
DART_DEFINES=""
while IFS='=' read -r key value || [ -n "$key" ]; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
    
    # Remove leading/trailing whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    
    # Skip if key or value is empty after trimming
    [[ -z "$key" || -z "$value" ]] && continue
    
    DART_DEFINES="$DART_DEFINES --dart-define=$key=$value"
done < "$ENV_FILE"

# Change to app directory
cd "$PROJECT_ROOT/app"

# Default to 'run' if no arguments provided
FLUTTER_CMD="${1:-run}"

# If first arg is not a flutter command, prepend 'run'
if [[ "$FLUTTER_CMD" != "run" && "$FLUTTER_CMD" != "build" && "$FLUTTER_CMD" != "test" ]]; then
    FLUTTER_CMD="run"
    FLUTTER_ARGS="$@"
else
    shift
    FLUTTER_ARGS="$@"
fi

echo "🚀 Running: flutter $FLUTTER_CMD $DART_DEFINES $FLUTTER_ARGS"
echo ""

# Execute flutter with dart defines
flutter $FLUTTER_CMD $DART_DEFINES $FLUTTER_ARGS
