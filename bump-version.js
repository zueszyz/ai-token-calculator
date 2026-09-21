// bump-version.js — 自动递增版本号脚本
// 功能：每次打包发行包时调用，自动把 package.json 的 version 字段 patch 段 +1
// 例如 1.0.0 → 1.0.1 → 1.0.2，用于追踪每次发行的迭代
// 行为：仅修改 package.json 文件本身，不创建 git commit/tag（保持工作目录干净）
// 调用方式：node bump-version.js （或在 package.json 的 scripts 中通过 npm run bump 触发）
// 返回：在控制台打印新版本号，并模块导出 newVersion 供其他脚本 require 使用

const fs = require('fs');
const path = require('path');

// 定位项目根目录的 package.json
const pkgPath = path.join(__dirname, 'package.json');

// 读取并解析 JSON（注意：JSON.parse 不允许注释与尾逗号，package.json 必须严格合法）
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));

// 拆解语义化版本号三段：major.minor.patch
const parts = pkg.version.split('.').map(Number);
if (parts.length !== 3 || parts.some(isNaN)) {
  console.error(`错误: package.json 的 version 字段格式不合法（应为 X.Y.Z），当前为 "${pkg.version}"`);
  process.exit(1);
}
const [major, minor, patch] = parts;

// patch 段 +1，major/minor 不变（如需 bump 更高级别，请手动 npm version minor/major）
const newVersion = `${major}.${minor}.${patch + 1}`;

// 写回 package.json（保持 2 空格缩进 + 末尾换行，符合 npm 规范）
pkg.version = newVersion;
fs.writeFileSync(pkgPath, JSON.stringify(pkg, null, 2) + '\n', 'utf8');

// 控制台输出，方便其他脚本捕获（如 `for /f` in bat、`$(...)` in sh）
console.log(newVersion);

// 模块导出，供 build-electron.js 等 Node 脚本 require 时直接拿到新版本号字符串
module.exports = newVersion;
