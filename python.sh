#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(dirname "$SCRIPT_DIR")"

echo "==> Bootstrapping Python environment..."

# Enforce Python 3 availability
command -v python3 >/dev/null 2>&1 || { echo "Error: Python3 required." >&2; exit 1; }

# Setup localized isolated execution sandbox
if [ ! -d ".venv" ]; then
  echo "==> Creating localized virtual environment (.venv)..."
  python3 -m venv .venv
fi

# Activate local scope
source .venv/bin/activate

# Execute modern dependency trees or fallback to raw pip requirements
if command -v poetry &> /dev/null; then
  poetry install --no-root
else
  pip install --upgrade pip
  [ -f requirements.txt ] && pip install -r requirements.txt
fi

echo "==> Setup complete. Run 'source .venv/bin/activate' to enter the runtime shell."
