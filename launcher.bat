@echo off
chcp 65001 >nul
title AI Token Calculator Pro
cd /d "%~dp0"

echo ╔══════════════════════════════════════════╗
echo ║   🧮 AI Token Calculator Pro  v1.0.0    ║
echo ╚══════════════════════════════════════════╝
echo.

:: Check for Node.js
where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✅ Node.js found — starting server...
    start http://127.0.0.1:8866
    node server-embed.js 8866
    goto :end
)

:: Try portable Node.js
if exist "%~dp0nodejs\node.exe" (
    echo ✅ Portable Node.js found — starting server...
    start http://127.0.0.1:8866
    "%~dp0nodejs\node.exe" server-embed.js 8866
    goto :end
)

:: Node.js not found
echo ╔══════════════════════════════════════════╗
echo ║ ❌ Node.js not found!                   ║
echo ║                                          ║
echo ║ Install from: https://nodejs.org         ║
echo ║ Or run: install-portable-node.bat        ║
echo ║                                          ║
echo ║ Press any key to open HTML directly...   ║
echo ╚══════════════════════════════════════════╝
pause >nul
start "" "%~dp0token-calculator.html"
echo ⚠ Direct file opening — some features (tokenizer) may not work.
pause

:end
