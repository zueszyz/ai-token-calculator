# app.py — AI Token Calculator Pro standalone desktop app
# Uses pywebview for native WebView + embedded HTTP server
# Bundled with PyInstaller for cross-platform executables

import os
import sys
import io
import http.server
import threading
import socket

# 修复 Windows 控制台编码问题
# Windows 默认使用 GBK 编码，无法输出 emoji 等 Unicode 字符
# 将 stdout/stderr 重配置为 UTF-8，遇到无法编码的字符时用 ? 替代而不是报错
# 注意：--windowed 模式下 stdout/stderr 为 None，需要先检查
if sys.platform == 'win32':
    if sys.stdout is not None and hasattr(sys.stdout, 'buffer'):
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    elif sys.stdout is None:
        # windowed 模式下 stdout 为 None，重定向到空设备以避免 print() 报错
        sys.stdout = open(os.devnull, 'w', encoding='utf-8')
    if sys.stderr is not None and hasattr(sys.stderr, 'buffer'):
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    elif sys.stderr is None:
        sys.stderr = open(os.devnull, 'w', encoding='utf-8')

def find_free_port():
    """查找可用的端口号，避免端口冲突"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(('127.0.0.1', 0))
        return s.getsockname()[1]

def get_resource_path(relative_path):
    """
    获取资源文件的绝对路径
    支持开发模式和 PyInstaller 打包后的运行模式：
    - 开发模式：基于脚本所在目录
    - 打包模式：基于 PyInstaller 解压的临时目录 (_MEIPASS)
    """
    # PyInstaller 打包后，资源被解压到 sys._MEIPASS 临时目录
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    # 开发模式下，基于当前脚本所在目录
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), relative_path)

# 配置
PORT = find_free_port()
HOST = '127.0.0.1'

# 加载 HTML 内容
HTML_PATH = get_resource_path('token-calculator.html')
if not os.path.exists(HTML_PATH):
    # 如果主路径找不到，尝试其他可能的位置
    alt_paths = [
        os.path.join(os.getcwd(), 'token-calculator.html'),
    ]
    for alt_path in alt_paths:
        if os.path.exists(alt_path):
            HTML_PATH = alt_path
            break

if not os.path.exists(HTML_PATH):
    print(f"错误: 找不到 token-calculator.html 文件")
    print(f"尝试查找的路径:")
    print(f"  - {HTML_PATH}")
    print(f"  - {os.path.join(os.getcwd(), 'token-calculator.html')}")
    input("按回车键退出...")
    sys.exit(1)

print(f"加载 HTML 文件: {HTML_PATH}")
with open(HTML_PATH, 'r', encoding='utf-8') as f:
    HTML_CONTENT = f.read()

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path in ('/', '/index.html', '/token-calculator.html'):
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.end_headers()
            self.wfile.write(HTML_CONTENT.encode('utf-8'))
        elif self.path == '/favicon.ico':
            self.send_response(200)
            self.send_header('Content-Type', 'image/svg+xml')
            self.end_headers()
            self.wfile.write(b'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">\xf0\x9f\xa7\xae</text></svg>')
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        pass  # Suppress logging

def start_server():
    server = http.server.HTTPServer((HOST, PORT), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    return server

def main():
    import webview
    
    # Start embedded HTTP server
    server = start_server()
    url = f'http://{HOST}:{PORT}'
    print(f'🧮 AI Token Calculator Pro — {url}')
    
    # Create native WebView window
    webview.create_window(
        title='AI Token Calculator Pro',
        url=url,
        width=1400,
        height=900,
        min_size=(900, 600),
        resizable=True,
        fullscreen=False,
    )
    
    webview.start()
    server.shutdown()

if __name__ == '__main__':
    main()
