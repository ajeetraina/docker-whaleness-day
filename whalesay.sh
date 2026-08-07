#!/usr/bin/env bash
#
# whalesay.sh — the Docker Sandboxes (sbx) take on docker/whalesay.
#
# The classic demo is:
#     docker run docker/whalesay cowsay boo
#
# This is the same whale, but it talks from inside an isolated Docker
# Sandbox created with `sbx` instead of a plain container:
#     ./whalesay.sh boo
#
set -euo pipefail

SANDBOX="${SBX_WHALESAY_NAME:-whalesay}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: ./whalesay.sh [message...]
       ./whalesay.sh --clean       Stop and remove the whalesay sandbox
       ./whalesay.sh --help        Show this help

Examples:
  ./whalesay.sh                     # the whale greets you
  ./whalesay.sh boo
  ./whalesay.sh Happy Whaleness Day
  ./whalesay.sh "sbx > docker run"
EOF
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  --clean)   sbx rm --force "$SANDBOX" >/dev/null 2>&1 || true
             echo "🧹 Removed sandbox '$SANDBOX'."; exit 0 ;;
esac

MESSAGE="${*:-Hello from Docker Sandboxes 🐳}"

# Create the sandbox once; later runs reuse it.
if ! sbx ls 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx "$SANDBOX"; then
  echo "🐳 Creating sandbox '$SANDBOX'..." >&2
  sbx create --name "$SANDBOX" shell "$HERE" >/dev/null
fi

# Make the whale talk from inside the sandbox.
#   - perl already ships in the sandbox image
#   - cowsay + docker.cow live in this workspace, bind-mounted into the sandbox
#     at the same path, so COWPATH=$HERE resolves inside the container too.
exec sbx exec -e COWPATH="$HERE" "$SANDBOX" perl "$HERE/cowsay" -f docker "$MESSAGE"
