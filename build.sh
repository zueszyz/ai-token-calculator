#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "╔══════════════════════════════════════════╗"
echo "║   AI Token Calculator Pro — Packager    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# [0/2] 自动递增版本号（patch +1，写回 package.json）
echo "[0/2] 自动递增版本号..."
node bump-version.js && VERSION=$(node -p "require('./package.json').version") && echo "  当前版本: $VERSION"

rm -rf pkg
mkdir -p pkg/win-x64 pkg/macos pkg/linux-x64

echo "[1/2] Copying files..."
cp token-calculator.html pkg/win-x64/ pkg/macos/ pkg/linux-x64/
cp server-embed.js pkg/win-x64/ pkg/macos/ pkg/linux-x64/

# Windows launcher
cat > pkg/win-x64/启动.bat << 'BATEOF'
@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo AI Token Calculator Pro — Starting...
node server-embed.js
if %ERRORLEVEL% NEQ 0 (
  echo Node.js not found — opening HTML directly.
  start "" token-calculator.html
)
BATEOF

# macOS launcher
cat > pkg/macos/启动.command << 'MACEOF'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"
if command -v node &> /dev/null; then
  open http://127.0.0.1:8866 &
  node server-embed.js
else
  echo "Node.js not found. Install from https://nodejs.org"
  open token-calculator.html
fi
MACEOF
chmod +x pkg/macos/启动.command

# Linux launcher
cp pkg/macos/启动.command pkg/linux-x64/启动.sh
chmod +x pkg/linux-x64/启动.sh

echo "  ✅ Done"

echo "[2/2] Creating archives..."
cd pkg
# 产物文件名嵌入版本号，例如 ai-token-calculator-win-x64-1.0.1.zip
zip -r "ai-token-calculator-win-x64-${VERSION}.zip" win-x64/
zip -r "ai-token-calculator-macos-${VERSION}.zip" macos/
tar -czf "ai-token-calculator-linux-x64-${VERSION}.tar.gz" linux-x64/
cd ..

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   🎉 Packaging Complete!                ║"
echo "╚══════════════════════════════════════════╝"
echo ""
ls -lh pkg/*.zip pkg/*.tar.gz 2>/dev/null
echo ""
echo "Usage: Extract, install Node.js, double-click launcher."
