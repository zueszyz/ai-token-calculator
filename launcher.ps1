# AI-Token-Calculator-Pro.ps1
# Windows standalone launcher — creates a native app window
# Requirements: Windows 10/11 (uses Edge WebView2 / msedge --app mode)
# Convert to EXE with: powershell -Command "ps2exe ..."

param([int]$Port = 19876)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$htmlPath = Join-Path $scriptDir 'token-calculator.html'

if (-not (Test-Path $htmlPath)) {
    $htmlPath = Join-Path (Get-Location) 'token-calculator.html'
}

$html = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)
$url = "http://127.0.0.1:$Port"

# Start HTTP server using .NET HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:$Port/")
try { $listener.Start() } catch {
    Write-Host "Port $Port busy, trying random port..."
    $Port = 0
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add("http://127.0.0.1:0/")
    $listener.Start()
    $Port = ($listener.Prefixes[0] -replace '.*:(\d+)/.*', '$1')
    $url = "http://127.0.0.1:$Port"
}

# Background job to handle HTTP requests
$job = Register-ObjectEvent -InputObject $listener -EventName 'GetContext' -Action {
    $ctx = $EventArgs.RequestContext
    $r = $ctx.Request; $w = $ctx.Response
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($html)
    $w.ContentType = 'text/html; charset=utf-8'
    $w.ContentLength64 = $bytes.Length
    $w.OutputStream.Write($bytes, 0, $bytes.Length)
    $w.OutputStream.Close()
} | Out-Null

# Open Edge in app mode (creates standalone window)
$edgePaths = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "${env:ProgramFiles}\Microsoft\Edge\Application\msedge.exe",
    "${env:LOCALAPPDATA}\Microsoft\Edge\Application\msedge.exe"
)
$edge = $null
foreach ($p in $edgePaths) { if (Test-Path $p) { $edge = $p; break } }

if ($edge) {
    Start-Process -FilePath $edge -ArgumentList "--app=$url", '--window-size=1400,900', '--no-first-run'
} else {
    # Fallback: open default browser
    Start-Process $url
}

Write-Host "AI Token Calculator Pro running at $url"
Write-Host "Close this window to stop the server."

# Wait for user to close
while ($listener.IsListening) {
    Start-Sleep -Seconds 1
}

$listener.Stop()
$listener.Close()
