#!/usr/bin/env node
'use strict';
const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const PORT = parseInt(process.env.PORT || process.argv[2] || '8866', 10);
const HOST = '127.0.0.1';

/**
 * 查找 HTML 文件路径
 * 支持打包后的 exe 运行环境（pkg 打包时 __dirname 指向虚拟文件系统）
 * 也支持开发模式下直接运行 node server-embed.js
 */
function findHTML() {
  // pkg 打包后，文件被嵌入到可执行文件中，路径以 'snapshot' 开头
  // 优先使用 __dirname（pkg 会将文件映射到虚拟路径）
  const candidates = [
    path.join(__dirname, 'token-calculator.html'),
    path.join(process.cwd(), 'token-calculator.html'),
  ];
  
  for (const p of candidates) {
    try {
      if (fs.existsSync(p)) return p;
    } catch (e) {
      // 忽略权限或虚拟文件系统错误
    }
  }
  throw new Error('Cannot find token-calculator.html');
}

const htmlPath = findHTML();
let HTML_CONTENT = fs.readFileSync(htmlPath, 'utf-8');

const server = http.createServer((req, res) => {
  const url = new URL(req.url, `http://${HOST}`);
  if (url.pathname === '/' || url.pathname.endsWith('.html')) {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(HTML_CONTENT);
    return;
  }
  if (url.pathname === '/favicon.ico') {
    res.writeHead(200, { 'Content-Type': 'image/svg+xml' });
    res.end('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><text y=".9em" font-size="90">🧮</text></svg>');
    return;
  }
  res.writeHead(404);
  res.end('Not Found');
});

server.listen(PORT, HOST, () => {
  const url = `http://${HOST}:${server.address().port}`;
  console.log('╔══════════════════════════════════════════╗');
  console.log('║   🧮 AI Token 计算器 Pro  v1.0.0        ║');
  console.log(`║   地址: ${url}          ║`);
  console.log('║   按 Ctrl+C 停止                         ║');
  console.log('╚══════════════════════════════════════════╝');
  const plat = process.platform;
  const cmd = plat === 'win32' ? 'start' : (plat === 'darwin' ? 'open' : 'xdg-open');
  exec(`${cmd} ${url}`, () => {});
});

process.on('SIGINT', () => { console.log('\n已停止'); process.exit(0); });
