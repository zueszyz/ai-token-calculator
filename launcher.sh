#!/bin/bash
# ═══════════════════════════════════════════════
#  AI Token Calculator Pro — Launcher
#  macOS / Linux
# ═══════════════════════════════════════════════

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "╔══════════════════════════════════════════╗"
echo "║   🧮 AI Token Calculator Pro  v1.0.0    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

PORT=${1:-8866}
URL="http://127.0.0.1:${PORT}"

# Check for Node.js
NODE_CMD=""
if command -v node &> /dev/null; then
    NODE_CMD="node"
elif [ -f "$DIR/nodejs/bin/node" ]; then
    NODE_CMD="$DIR/nodejs/bin/node"
elif [ -f "$DIR/node/bin/node" ]; then
    NODE_CMD="$DIR/node/bin/node"
fi

if [ -n "$NODE_CMD" ]; then
    echo "✅ Node.js found — starting server..."
    
    # Auto-open browser
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$URL" 2>/dev/null &
    else
        xdg-open "$URL" 2>/dev/null &
    fi
    
    "$NODE_CMD" server-embed.js "$PORT"
else
    echo "❌ Node.js not found!"
    echo "Install from: https://nodejs.org"
    echo ""
    echo "Opening HTML directly (some features may not work)..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$DIR/token-calculator.html"
    else
        xdg-open "$DIR/token-calculator.html"
    fi
fi
