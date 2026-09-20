@echo off
cd /d "%~dp0"
echo === AI Token Calculator Pro — Standalone Build ===

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
powershell -Command "Compress-Archive -Path 'dist-standalone\win\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Win.zip' -Force"
powershell -Command "Compress-Archive -Path 'dist-standalone\mac\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Mac.zip' -Force"
powershell -Command "Compress-Archive -Path 'dist-standalone\linux\*' -DestinationPath 'dist-standalone\AI-Token-Calculator-Linux.zip' -Force"

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
