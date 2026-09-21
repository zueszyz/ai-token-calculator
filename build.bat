@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo === AI Token Calculator Pro - Packager ===
echo.

REM [0/2] 自动递增版本号（patch +1，写回 package.json）
echo [0/2] 自动递增版本号...
call node bump-version.js
if errorlevel 1 (
    echo   警告: 版本号递增失败，继续使用当前版本
) else (
    REM 读取 package.json 的 version 字段，赋给环境变量 VERSION
    for /f "delims=" %%v in ('node -p "require('./package.json').version"') do set VERSION=%%v
    echo   当前版本: %VERSION%
)

if exist "pkg" rmdir /s /q "pkg"
mkdir "pkg\win" 2>nul
mkdir "pkg\mac" 2>nul
mkdir "pkg\linux" 2>nul

echo [1/2] Copying files...
copy /y "token-calculator.html" "pkg\win\" >nul
copy /y "token-calculator.html" "pkg\mac\" >nul
copy /y "token-calculator.html" "pkg\linux\" >nul
copy /y "server-embed.js" "pkg\win\" >nul
copy /y "server-embed.js" "pkg\mac\" >nul
copy /y "server-embed.js" "pkg\linux\" >nul
echo   OK - Core files copied

echo [2/2] Creating archives...
REM 产物 zip 文件名嵌入版本号，例如 ai-token-calculator-win-1.0.1.zip
powershell -Command "Compress-Archive -Path 'pkg\win\*' -DestinationPath 'ai-token-calculator-win-%VERSION%.zip' -Force"
powershell -Command "Compress-Archive -Path 'pkg\mac\*' -DestinationPath 'ai-token-calculator-mac-%VERSION%.zip' -Force"
powershell -Command "Compress-Archive -Path 'pkg\linux\*' -DestinationPath 'ai-token-calculator-linux-%VERSION%.zip' -Force"

echo.
echo === Done! ===
echo.
echo Files created:
dir /b ai-token-calculator-*.zip 2>nul
echo.
echo How to use:
echo   1. Extract the ZIP file
echo   2. Install Node.js from https://nodejs.org
echo   3. Run: node server-embed.js
echo   4. Open http://127.0.0.1:8866 in browser
echo.
echo Or double-click token-calculator.html to open directly
echo (some CDN features may need internet connection)
pause
