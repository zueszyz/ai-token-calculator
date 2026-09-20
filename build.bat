@echo off
cd /d "%~dp0"

echo === AI Token Calculator Pro - Packager ===
echo.

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
powershell -Command "Compress-Archive -Path 'pkg\win\*' -DestinationPath 'ai-token-calculator-win.zip' -Force"
powershell -Command "Compress-Archive -Path 'pkg\mac\*' -DestinationPath 'ai-token-calculator-mac.zip' -Force"
powershell -Command "Compress-Archive -Path 'pkg\linux\*' -DestinationPath 'ai-token-calculator-linux.zip' -Force"

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
