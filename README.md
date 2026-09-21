# AI Token Calculator Pro

> 🧮 实时 Token 计数 · 74 个模型编码速查 · K/M 十进制换算 · 65 家服务商价格对比

[中文](#中文) | [English](#english)

---

## 中文

### ✨ 功能特性

应用采用「左输入 + 右工具」双栏布局，右侧共 **7 个功能选项卡**：

| 模块 | 说明 |
| --- | --- |
| 🔤 **实时分词（左栏）** | 输入任意文本即时切分 Token，每个 Token 用不同底色可视化；点击单个 Token 可查看其 **Token 内容 / ID / 位置 / 字节数**；左右分栏宽度可拖动 |
| 🧠 **模型选择器** | 内置 69 个模型，切换后自动套用对应编码方案；模型旁显示**上下文窗口占用徽标**（绿色=充足 / 粉色=超限），实时判断文本能否装得下 |
| 📊 **对比选项卡** | 65 家内置服务商的输入费 / 输出费 / 总费用明细表，**最便宜的一项自动高亮**，美元与人民币混合计价 |
| 🔢 **1K=1000 选项卡** | 专门解释 AI 行业十进制惯例（1K=1,000、1M=1,000,000，区别于计算机 1024 二进制），支持 `K / M / 千 / 万 / 亿` 简写输入 |
| 🧬 **编码选项卡** | 全部模型家族的分词器（Tokenizer）架构、词表大小、适用模型速查表 |
| 🖼 **图片选项卡** | 按图片尺寸（宽 × 高）估算 GPT-4o Vision 等多模态模型的图片 Token 与费用 |
| 🔄 **换算选项卡** | 字符 ↔ Token ↔ 英文单词 ↔ 页面页数 多单位互转 |
| ➕ **自定义选项卡** | 添加任意 AI 服务的输入 / 输出单价，数据保存在浏览器 `localStorage`，刷新不丢失 |
| 📖 **知识选项卡** | 内置知识库：什么是 Token、BPE 分词原理、不同语言的 Token 密度差异 |

### 🔀 两种计数模式

1. **真实分词器（Real Tokenizer）** — 通过 ES Module 动态加载 CDN 上的
   [`gpt-tokenizer@2.8.1`](https://cdn.jsdelivr.net/npm/gpt-tokenizer@2.8.1/)，
   支持 `o200k_base`、`cl100k_base`、`p50k_base`、`p50k_edit`、`r50k_base` 五种 OpenAI 编码，
   结果精确（需要网络，且建议通过 http 方式打开以避免模块跨域限制）。
2. **编码感知估算（Estimation）** — 离线可用，按各编码家族的中 / 英文字符比例系数估算，
   页面左上角徽标会明确标注当前处于「真实 / 估算」哪种模式。

> 注：Claude、Gemini、Llama、DeepSeek 等非 OpenAI 系模型暂无浏览器版分词器，
> 统一使用各自编码家族的比例系数估算。

### 🚀 快速开始（Windows 11）

#### 方式一：浏览器直接打开（零依赖）

```powershell
# 双击文件，或在命令行执行
start token-calculator.html
```

基础功能全部可用；真实分词器需要联网，且 `file://` 方式下 ES Module 可能被浏览器拦截，
此时自动降级为估算模式。

#### 方式二：Node.js 本地服务（真实分词，推荐）

```powershell
# 安装 Node.js：https://nodejs.org
node server-embed.js          # 默认端口 8866
node server-embed.js 9000     # 也可自定义端口
```

启动后自动打开浏览器，访问 `http://127.0.0.1:8866`，按 `Ctrl+C` 停止。

#### 方式三：一键启动脚本

| 平台 | 命令 / 操作 | 说明 |
| --- | --- | --- |
| Windows | 双击 `launcher.bat` | 自动探测 Node.js，启动 8866 端口服务；无 Node 时回退为直接打开 HTML |
| Windows | `powershell -ExecutionPolicy Bypass -File launcher.ps1` | 使用系统自带 **Edge --app 模式**开原生窗口，无需安装 Node |
| macOS | 双击 `ai-token-calculator.command` 或 `bash launcher.sh` | 自动探测 Node.js 并打开浏览器 |
| Linux | `bash launcher.sh` | 同上 |

#### 方式四：Electron 桌面应用

```powershell
npm install
npm start          # 开发模式直接启动 Electron（注意：不是启动网页服务）
npm run dist       # 用 electron-builder 打包 portable 单文件 exe
```

打包产物：`dist-electron\AI-Token-Calculator-Pro-1.0.0.exe`（免安装，双击即用）。

如果 electron-builder 在 Windows 下遇到目录重命名失败，可改用内置的自定义打包脚本：

```powershell
node build-electron.js   # 从本机 Electron 缓存解压 → 复制应用 → 打 asar → 生成 portable zip
```

#### 方式五：Python 桌面应用（pywebview）

```powershell
pip install pywebview
python app.py
```

`app.py` 会在随机空闲端口启动内嵌 HTTP 服务，再调用系统原生 WebView 开窗口，
可用 PyInstaller 打包成各平台可执行文件。

### 📁 项目结构

```
ai-token-calculator/
├── token-calculator.html      # ★ 主应用（单文件、零构建，CDN 按需加载分词器）
├── server-embed.js            # Node.js HTTP 服务（默认 8866，自动开浏览器，支持 pkg 打包）
├── app.py                     # Python 版桌面应用（pywebview 原生窗口 + 内嵌 HTTP 服务）
├── electron-main.js           # Electron 主进程（内嵌 19876 端口服务，规避 file:// 跨域）
├── build-electron.js          # Electron 自定义打包脚本（electron-builder 失败时的备选）
├── global-ai-models.md        # 全球 AI 模型数据文档（编码 / 上下文窗口 / 价格）
├── global-ai-models.json      # 同上的结构化版本（数据源版本 2026.09-extended，供更新 HTML 内嵌数据）
├── package.json               # npm 配置与 electron-builder 打包配置
├── launcher.bat               # Windows 启动脚本（Node 服务，8866）
├── launcher.ps1               # Windows PowerShell 启动脚本（Edge --app 窗口，19876）
├── launcher.sh                # macOS / Linux 启动脚本
├── launcher-mac.sh            # macOS .app 风格启动脚本（Chrome/Edge app 模式）
├── ai-token-calculator.command# macOS 双击入口（转调 launcher.sh）
├── build.bat                  # Windows 打包脚本（生成三平台 zip：HTML + server-embed.js）
├── build.sh                   # macOS / Linux 打包脚本（生成 zip / tar.gz，含各平台启动器）
├── build-standalone.bat       # 生成纯 HTML 免 Node 版（dist-standalone，附 Edge app 启动器）
├── dist-standalone/           # 免依赖版构建产物（win / mac / linux 三目录 + ZIP）
├── reqnav/                    # 子项目：需求导航侧栏插件（独立维护，详见该目录 README）
├── LICENSE                    # MIT 许可证
└── .gitignore
```

### 🧬 支持模型（HTML 模型库内嵌 74 个，选择器收录 69 个）

| 分类 | 代表模型 |
| --- | --- |
| 🌍 OpenAI | GPT-6 Astra、GPT-5.6 Sol/Terra/Luna、GPT-4o、GPT-4o-mini、GPT-3.5 Turbo、o4-mini、Codex、Cyber、Sora |
| 🌍 Anthropic | Claude Fable 5.1/Mythos 5.1、Fable 5、Opus 5、Sonnet 5、Sonnet 4.6、Haiku 4.5 |
| 🌍 Google | Gemini 3.8 Flash、3.5 Flash、3.1 Pro、3.1 Flash-Lite、Veo |
| 🌍 xAI | Grok 4.6、Grok 4.5、Grok 4.3、Grok 4.20、Grok 4.20 Multi-Agent、Code Fast 1 |
| 🌍 Meta / Mistral | Llama 3.1 405B、Llama 4 Maverick、Mistral Large、Mistral Large 3、Mistral Small 4 |
| 🇨🇳 DeepSeek | DeepSeek V4.1-Flash（deepseek-flash）、V4-Pro-0813、DeepSeek-R1 |
| 🇨🇳 阿里云 | 通义千问 Qwen3.8-Max、Qwen3.7-Max、Max/Plus/Long、通义万相 |
| 🇨🇳 字节跳动 | 豆包 Seed 2.1 Pro/Turbo、Seed 2.0 Pro/Mini、Seedance |
| 🇨🇳 月之暗面 | Kimi K3、Kimi K2.8 Preview、Kimi K2.7 Code |
| 🇨🇳 百度 | 文心一言 ERNIE 5.1、ERNIE Speed |
| 🇨🇳 智谱 AI | GLM-5.3、GLM-5.3-Flash、GLM-5.2、GLM-4.7-Flash、CogVideoX |
| 🇨🇳 其他国内厂商 | MiniMax-M3/M2.7、腾讯混元 T1、Hunyuan-a13b、Tencent Hy4 preview、零一万物 Yi-Lightning、阶跃星辰 Step-2、讯飞星火 V4、商汤日日新 5.0、快手可灵、Runway |

> `global-ai-models.json`（2026.09-extended 版）已收录 GPT-6 Astra、Claude Fable 5.1、Gemini 3.8 Flash、
> DeepSeek V4.1-Flash/V4-Pro-0813、GLM-5.3、Kimi K3、Qwen3.8-Max 等 **94 个新一代模型**数据（HTML 模型库实测 74 个 + 65 条定价），
> 是同步更新 HTML 内嵌模型表的数据源。

### 🔢 Token 编码参考

| 编码 | 厂商 | 词表大小 | 典型模型 |
| --- | --- | --- | --- |
| `cl100k_base` | OpenAI | 100,256 | GPT-4、GPT-4 Turbo、GPT-3.5 Turbo |
| `o200k_base` | OpenAI | 200,000 | GPT-4o、o1、o3-mini |
| `p50k_base` / `r50k_base` | OpenAI | 50,281 / 50,257 | Codex、早期 GPT-3 |
| `Claude BPE` | Anthropic | ~150,000 | Claude 3 系列 |
| `SentencePiece` | Google | ~256,000 | Gemini 全系列 |
| `Llama3 BPE` | Meta | 128,256 | Llama 3 / 3.1 / 3.2 |
| `DeepSeek BPE` | DeepSeek | 128,000 | DeepSeek-V3、R1、Coder |
| `Qwen BPE` | 阿里云 | 151,936 | 通义千问、QwQ |
| `Doubao BPE` | 字节跳动 | 131,072 | 豆包系列 |
| `Moonshot BPE` | 月之暗面 | 131,072 | Kimi 系列 |
| `ERNIE / GLM / MiniMax / Yi BPE` 等 | 国内各厂商 | 65K–150K | 文心、GLM、MiniMax、Yi 等 |

### 🧩 子项目：reqnav

`reqnav/` 是一个**独立的「需求导航」浏览器侧栏插件**（零依赖 Vanilla JS），
可注入到 DeepSeek Harness 等对话式 AI Web 界面中，自动识别需求列表、点击跳转、
键盘翻页、宽度拖动、localStorage 持久化。它与本计算器无代码耦合，
文档与自测方式见 [reqnav/README.md](reqnav/README.md)。

### 📦 发行包构建方式一览

| 命令 | 产物 | 适用场景 |
| --- | --- | --- |
| `npm run dist` | `dist-electron/AI-Token-Calculator-Pro-1.0.0.exe` | Windows 免安装单文件（官方首选） |
| `node build-electron.js` | `dist-electron/*.zip`（含 exe 与运行时） | electron-builder 失败时的备选 |
| `build-standalone.bat` | `dist-standalone/AI-Token-Calculator-{Win,Mac,Linux}.zip` | 纯 HTML + 启动器，目标机器无需 Node |
| `build.bat` | `ai-token-calculator-{win,mac,linux}.zip` | HTML + server-embed.js，目标机器需安装 Node |
| `build.sh` | `pkg/` 下 zip / tar.gz | 同上，含中文命名的各平台启动器 |

### 📄 许可证

本项目基于 **MIT License** 开源，详见 [LICENSE](LICENSE)。

---

## English

### Overview

A powerful, self-contained AI Token Calculator with real-time token visualization,
74 embedded AI models and multi-provider price comparison (65 built-in providers, USD & CNY).
Runs entirely in the browser; a local Node.js server or Electron wrapper unlocks the exact tokenizer.

### Features

- **Real-time token splitting** with color-coded visualization and per-token details (ID / position / bytes)
- **7 tool tabs**: Price Compare · 1K=1000 Decimal · Encoding Reference · Image Tokens · Unit Converter · Custom Provider · Knowledge Base
- **Context window badges** that warn when your text exceeds a model's limit
- **Cheapest-provider highlighting** across international and Chinese vendors
- Add custom pricing; persisted in `localStorage`

### Run Modes

| Mode | Command | Notes |
| --- | --- | --- |
| Browser | open `token-calculator.html` | Zero install; CDN tokenizer may fall back to estimation under `file://` |
| Node.js server | `node server-embed.js` | Serves at `http://127.0.0.1:8866`, auto-opens browser |
| Windows app-mode | `powershell -ExecutionPolicy Bypass -File launcher.ps1` | Edge `--app` window, no Node required |
| Electron (dev) | `npm install && npm start` | Launches the Electron desktop app |
| Electron (build) | `npm run dist` | Portable exe in `dist-electron/` |
| Python | `pip install pywebview && python app.py` | Native WebView window via embedded HTTP server |

### Tech Stack

- **Frontend**: Vanilla JS in a single HTML file (no build step); dark GitHub-style UI
- **Tokenizer**: [`gpt-tokenizer@2.8.1`](https://cdn.jsdelivr.net/npm/gpt-tokenizer@2.8.1/)
  loaded on demand via ES modules (`o200k_base`, `cl100k_base`, `p50k_base`, `p50k_edit`, `r50k_base`)
- **Offline fallback**: encoding-family-aware ratio estimation for Chinese / English text
- **Desktop**: Electron 43 + electron-builder (portable Windows target); alternative Python/pywebview build
- **Data**: `global-ai-models.md` / `global-ai-models.json` (data release 2026.09-extended, 74 embedded models + 65 pricing entries)

### License

MIT License — see [LICENSE](LICENSE).
