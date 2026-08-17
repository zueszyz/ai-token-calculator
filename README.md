# AI Token Calculator Pro

> 🧮 实时 Token 计数 · 65+ 模型编码速查 · 十进制换算 · 多服务商价格对比

[English](#english) | [中文](#中文)

---

## ✨ Features

- **Real-time Token Counting** — See how any text splits into tokens instantly, with color-coded visualization
- **65+ Model Support** — GPT-4o, Claude 3.5, Gemini 1.5 Pro, DeepSeek-V3/R1, 豆包, Kimi, 智谱, 通义千问, 文心一言, etc.
- **Encoding Reference** — Full tokenizer schema table for all major model families
- **1K=1,000 Decimal** — Dedicated tab explaining AI industry convention (≠ computer 1024 binary)
- **Multi-provider Price Comparison** — Input/output cost breakdown across 35+ providers (USD & CNY)
- **Context Window Checker** — See how many tokens fit in each model's context window
- **Image Token Estimation** — Estimate GPT-4o Vision cost by image dimensions
- **Unit Converter** — Characters ↔ Tokens ↔ English words ↔ Pages
- **Custom Provider** — Add your own pricing for any AI service
- **Knowledge Base** — Built-in explanations of what tokens are and how they work

## 🌐 Live Demo

Open `token-calculator.html` directly in any modern browser — no server required for most features.

For full tokenizer accuracy, use the Node.js server mode.

## 🚀 Quick Start

### Browser (no dependencies)

```bash
# Just open in browser
open token-calculator.html
# or
start token-calculator.html
```

### Node.js Server (recommended)

```bash
# Install Node.js from https://nodejs.org
npm install
npm start
# Opens at http://127.0.0.1:19876
```

### Desktop App (Windows)

Download from [Releases](https://github.com/zuesz/ai-token-calculator/releases) or build yourself:

```bash
npm install
npm run dist
# Find AI-Token-Calculator-Pro-1.0.0.exe in dist-electron/
```

## 📁 Project Structure

```
ai-token-calculator/
├── token-calculator.html    # Main app (self-contained, CDN-loaded)
├── server-embed.js          # Node.js HTTP server (serves HTML + opens browser)
├── electron-main.js         # Electron app wrapper
├── build-electron.js        # Electron packaging script
├── global-ai-models.md      # Model data & pricing reference
├── package.json             # npm config
└── .gitignore
```

## 🧬 Supported Models

| Category | Models |
|----------|--------|
| 🌍 OpenAI | GPT-4o, GPT-4o-mini, GPT-4 Turbo, o1, o3-mini, GPT-3.5 Turbo |
| 🌍 Anthropic | Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku |
| 🌍 Google | Gemini 2.5 Pro, Gemini 2.0 Flash, Gemini 1.5 Pro |
| 🇨🇳 DeepSeek | DeepSeek-V3, DeepSeek-R1, DeepSeek-Coder |
| 🇨🇳 阿里云 | 通义千问-Max/Plus/Turbo/Long, QwQ-Max |
| 🇨🇳 字节跳动 | 豆包 Pro-256K, 豆包 Lite |
| 🇨🇳 月之暗面 | Kimi (Moonshot) 8K/32K/128K |
| 🇨🇳 百度 | 文心一言 4.0, ERNIE Speed |
| 🇨🇳 智谱AI | GLM-4, GLM-4-Plus, GLM-3 Turbo |
| 🌍 Meta | Llama 3.1 405B, Llama 3 8B |
| 🌍 Others | Mistral Large, Grok-2, Cohere Command R+, and more |

## 🔢 Token Encoding Reference

| Encoding | Vendor | Vocabulary |
|----------|--------|------------|
| `cl100k_base` | OpenAI (GPT-4/3.5) | 100,256 |
| `o200k_base` | OpenAI (GPT-4o, o1/o3) | 200,000 |
| `Claude BPE` | Anthropic | ~150,000 |
| `SentencePiece` | Google Gemini | ~256,000 |
| `Llama3 BPE` | Meta | 128,256 |
| `DeepSeek BPE` | DeepSeek | 128,000 |
| `Qwen BPE` | 阿里云 | 151,936 |
| `Doubao BPE` | 字节跳动 | 131,072 |
| `Moonshot BPE` | 月之暗面 | 131,072 |

## 📊 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.

---

## English

### Overview

A powerful, self-contained AI Token Calculator with real-time visualization, 65+ model encodings, and multi-provider price comparison. Works entirely in the browser — no server required for basic features.

### Tech Stack

- **Frontend**: Vanilla JS (ES Modules), CDN-loaded tokenizer
- **Server**: Node.js (http.server + browser auto-open)
- **Desktop**: Electron 43
- **Token Data**: 65+ models, 35+ pricing providers

### Token Counting Modes

1. **Real tokenizer** — Loads `gpt-tokenizer` from CDN via ES modules (requires network)
2. **Estimation** — Encoding-aware ratio estimation (works offline)

### Build Desktop App

```bash
npm install
npm run dist    # outputs .exe to dist-electron/
```
