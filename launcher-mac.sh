#!/bin/bash
# ═══════════════════════════════════════════════════════
#  AI Token Calculator Pro — macOS .app launcher
#  Creates a native-looking window via Chrome/Edge app mode
# ═══════════════════════════════════════════════════════

DIR="$(cd "$(dirname "$0")" && pwd)"
HTML="$DIR/token-calculator.html"
PORT=${1:-19876}

if [ ! -f "$HTML" ]; then
    HTML="$DIR/../token-calculator.html"
fi

# Start a simple Python HTTP server
python3 -c "
import http.server, threading, os
with open('$HTML','r') as f: html = f.read()
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(s):
        s.send_response(200)
        s.send_header('Content-Type','text/html; charset=utf-8')
        s.end_headers()
        s.wfile.write(html.encode())
    def log_message(s,*a): pass
s = http.server.HTTPServer(('127.0.0.1',$PORT), H)
t = threading.Thread(target=s.serve_forever, daemon=True)
t.start()
import time; time.sleep(0.5)
" &

sleep 1

URL="http://127.0.0.1:$PORT"

# Try Chrome app mode first (best standalone experience)
if [ -d "/Applications/Google Chrome.app" ]; then
    open -a "Google Chrome" --args --app="$URL" --window-size=1400,900
elif [ -d "/Applications/Microsoft Edge.app" ]; then
    open -a "Microsoft Edge" --args --app="$URL" --window-size=1400,900
elif command -v chromium &> /dev/null; then
    chromium --app="$URL" --window-size=1400,900 &
else
    open "$URL"
fi

echo "AI Token Calculator Pro running at $URL"
echo "Close the browser window and press Ctrl+C to stop."
wait
