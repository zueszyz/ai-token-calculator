@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo === AI Token Calculator Pro — Standalone Build ===

REM [0/2] 自动递增版本号（patch +1，写回 package.json）
echo [0/2] 自动递增版本号...
call node bump-version.js
if errorlevel 1 (
    echo   警告: 版本号递增失败，继续使用当前版本
) else (
    for /f "delims=" %%v in ('node -p "require('./package.json').version"') do set VERSION=%%v
    echo   当前版本: %VERSION%
)

if exist "dist-standalone" rmdir /s /q "dist-standalone"
mkdir "dist-standalone\win"
mkdir "dist-standalone\mac"
mkdir "dist-standalone\linux"

echo [1/2] Copying files...
copy /y "token-calculator.html" "dist-standalone\win\" >nul
copy /y "token-calculator.html" "dist-standalone\mac\" >nul
copy /y "token-calculator.html" "dist-standalone\linux\" >nul
copy /y "launcher.ps1" "dist-standalone\win\" >nul
copy /y "launcher-mac.sh" "dist-standalone\mac\" >nul
echo   OK

echo [2/2] Creating ZIP packages...
REM 产物 zip 文件名嵌入版本号，例如 AI-Token-Calculator-Win-1.0.1.zip
powershell -Command "Compress-Archive -Path 'dist-standalone\win\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Win-%VERSION%.zip' -Force"
powershell -Command "Compress-Archive -Path 'dist-standalone\mac\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Mac-%VERSION%.zip' -Force"
powershell -Command "Compress-Archive -Path 'dist-standalone\linux\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Linux-%VERSION%.zip' -Force"

echo.
echo === Done! Files in dist-standalone\ ===
dir /b dist-standalone\AI-Token-Calculator-*.zip 2>nul
echo.
echo Usage:
echo   Windows: powershell -ExecutionPolicy Bypass -File launcher.ps1
echo   macOS:   bash launcher-mac.sh
echo   Linux:   bash launcher-mac.sh
echo.
echo Each ZIP includes token-calculator.html + launcher script.
pause
