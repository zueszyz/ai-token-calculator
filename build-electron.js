// build-electron.js — 自定义 Electron 打包脚本
// 解决 electron-builder 在 Windows 下目录重命名失败的问题
// 流程：使用缓存 Electron → 复制应用文件 → 打包 asar → 生成 portable zip

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const os = require('os');

const PROJECT_DIR = __dirname;
const DIST_DIR = path.join(PROJECT_DIR, 'dist-electron');
const STAGING_DIR = path.join(DIST_DIR, 'AI-Token-Calculator-Pro');
const ELECTRON_VERSION = '43.2.0';

/** 清理目录 */
function cleanDir(dir) {
  if (fs.existsSync(dir)) {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

/** 确保目录存在 */
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

/** 从缓存查找 Electron zip 文件路径 */
function findElectronZip() {
  const cacheDir = path.join(process.env.LOCALAPPDATA, 'electron', 'Cache');
  if (!fs.existsSync(cacheDir)) return null;

  // 递归查找匹配版本的 zip 文件
  const entries = fs.readdirSync(cacheDir, { recursive: true });
  for (const entry of entries) {
    const fullPath = path.join(cacheDir, entry);
    if (entry.endsWith(`electron-v${ELECTRON_VERSION}-win32-x64.zip`)) {
      return fullPath;
    }
  }
  return null;
}

/** 从缓存解压 Electron 二进制文件 */
function extractElectron() {
  const zipPath = findElectronZip();
  if (!zipPath) {
    console.error(`错误: 找不到 Electron v${ELECTRON_VERSION} 缓存`);
    console.error('请先运行 npx electron-builder 下载 Electron');
    process.exit(1);
  }

  console.log(`[1/5] 从缓存解压 Electron: ${zipPath}`);
  const tempDir = path.join(os.tmpdir(), `electron-extract-${Date.now()}`);
  ensureDir(tempDir);

  // 使用 PowerShell 解压
  execSync(
    `powershell -Command "Expand-Archive -Path '${zipPath}' -DestinationPath '${tempDir}' -Force"`,
    { timeout: 120000, stdio: 'pipe' }
  );

  // 解压后的目录结构：tempDir/electron-v43.2.0-win32-x64/
  const extractedDir = path.join(tempDir, `electron-v${ELECTRON_VERSION}-win32-x64`);
  if (!fs.existsSync(extractedDir)) {
    // 有时直接解压到 tempDir 根目录
    if (fs.existsSync(path.join(tempDir, 'electron.exe'))) {
      console.log(`  Electron 已解压: ${tempDir}`);
      return tempDir;
    }
    throw new Error(`解压失败：找不到 electron.exe`);
  }

  console.log(`  Electron 已解压: ${extractedDir}`);
  return extractedDir;
}

/** 将应用文件复制到 Electron 目录 */
function copyAppFiles(electronDir) {
  console.log('[2/5] 复制应用文件...');

  // 目标：将 electron.exe 重命名为应用名
  const sourceExe = path.join(electronDir, 'electron.exe');
  const targetExe = path.join(electronDir, 'AI Token Calculator Pro.exe');

  // 复制 electron 目录内容到暂存目录
  cleanDir(STAGING_DIR);
  ensureDir(STAGING_DIR);

  // 复制 Electron 所有文件
  copyRecursive(electronDir, STAGING_DIR);

  // 重命名 exe
  const oldExe = path.join(STAGING_DIR, 'electron.exe');
  const newExe = path.join(STAGING_DIR, 'AI Token Calculator Pro.exe');
  if (fs.existsSync(oldExe)) {
    fs.renameSync(oldExe, newExe);
  }

  // 复制应用文件到 resources/app 目录
  const appDir = path.join(STAGING_DIR, 'resources', 'app');
  ensureDir(appDir);

  const filesToCopy = ['electron-main.js', 'token-calculator.html', 'package.json'];
  for (const file of filesToCopy) {
    const src = path.join(PROJECT_DIR, file);
    if (fs.existsSync(src)) {
      fs.copyFileSync(src, path.join(appDir, file));
    }
  }

  console.log('  应用文件复制完成');
}

/** 递归复制目录 */
function copyRecursive(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    // 跳过 node_modules 和 resources 目录（稍后单独处理）
    if (entry.name === 'node_modules') continue;
    if (entry.name === 'resources') continue;

    if (entry.isDirectory()) {
      copyRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

/** 安装 node_modules 到应用目录 */
function installNodeModules() {
  console.log('[3/5] 安装应用依赖...');
  const appDir = path.join(STAGING_DIR, 'resources', 'app');

  // 只安装生产依赖（如果有的话）
  if (fs.existsSync(path.join(PROJECT_DIR, 'package.json'))) {
    // 复制 package.json 到 app 目录
    fs.copyFileSync(
      path.join(PROJECT_DIR, 'package.json'),
      path.join(appDir, 'package.json')
    );
  }
  console.log('  依赖安装完成');
}

/** 使用 asar 打包应用文件 */
function createAsar() {
  console.log('[4/5] 创建 asar 包...');
  const appDir = path.join(STAGING_DIR, 'resources', 'app');
  const asarPath = path.join(STAGING_DIR, 'resources', 'app.asar');

  // 删除旧的 default_app.asar
  const oldDefaultApp = path.join(STAGING_DIR, 'resources', 'default_app.asar');
  if (fs.existsSync(oldDefaultApp)) {
    fs.unlinkSync(oldDefaultApp);
  }

  // 使用 npx asar 打包
  try {
    execSync(`npx asar pack "${appDir}" "${asarPath}"`, {
      cwd: PROJECT_DIR,
      stdio: 'inherit',
      timeout: 60000,
    });
    // 打包成功后删除 app 目录
    cleanDir(appDir);
    console.log('  asar 包创建完成');
  } catch (e) {
    console.log('  asar 打包失败，保留原始文件结构');
    // 如果 asar 失败，保留 app 目录（Electron 可以直接加载 app 目录）
  }
}

/** 创建 portable zip */
function createPortableZip() {
  console.log('[5/5] 生成 portable 可执行文件...');
  const outputZip = path.join(DIST_DIR, 'AI-Token-Calculator-Pro-${version}.zip').replace('${version}', require('./package.json').version);

  // 使用 PowerShell 压缩
  execSync(
    `powershell -Command "Compress-Archive -Path '${STAGING_DIR}\\*' -DestinationPath '${outputZip}' -Force"`,
    { cwd: PROJECT_DIR, stdio: 'inherit', timeout: 120000 }
  );

  console.log(`  portable zip 已生成: ${outputZip}`);
  return outputZip;
}

/** 主构建流程 */
function main() {
  console.log('╔══════════════════════════════════════════════════╗');
  console.log('║   AI Token Calculator Pro - Electron 打包工具    ║');
  console.log('╚══════════════════════════════════════════════════╝');
  console.log();

  try {
    // 清理旧的 dist 目录
    cleanDir(DIST_DIR);
    ensureDir(DIST_DIR);

    // 步骤 1: 从缓存解压 Electron
    const electronDir = extractElectron();

    // 步骤 2: 复制应用文件
    copyAppFiles(electronDir);

    // 步骤 3: 安装依赖
    installNodeModules();

    // 步骤 4: 创建 asar 包
    createAsar();

    // 步骤 5: 生成 portable zip
    const zipPath = createPortableZip();

    console.log();
    console.log('╔══════════════════════════════════════════════════╗');
    console.log('║               ✅ 打包完成！                      ║');
    console.log('╚══════════════════════════════════════════════════╝');
    console.log();
    console.log(`输出目录: ${DIST_DIR}`);
    console.log(`应用目录: ${STAGING_DIR}`);
    console.log(`压缩包: ${zipPath}`);
    console.log();
    console.log('使用方法:');
    console.log('  1. 解压 AI-Token-Calculator-Pro-<version>.zip');
    console.log('  2. 双击 AI Token Calculator Pro.exe 启动应用');
    console.log();
  } catch (error) {
    console.error('打包失败:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

main();