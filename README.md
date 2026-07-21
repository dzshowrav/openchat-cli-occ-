# OpenChat — Terminal-Native AI Coding Assistant

> **OpenChat** is a powerful, terminal-native AI coding assistant that runs entirely in your command line. It reads, writes, edits, searches, and executes code under AI guidance — all without leaving the terminal. Forked from the open-source [`opencode`](https://github.com/anomalyco/opencode) project (the open-source sibling of Anthropic's Claude Code CLI), OpenChat extends it with a **rich Terminal UI**, a **headless HTTP server**, a **desktop/web application**, and deep support for **multiple AI providers**.

[![Discord](https://img.shields.io/discord/1391832426048651334?style=flat-square&label=discord)](https://openchat.ai/discord)
[![npm](https://img.shields.io/npm/v/openchat-ai?style=flat-square)](https://www.npmjs.com/package/openchat-ai)
[![Build status](https://img.shields.io/github/actions/workflow/status/dzshowrav/openchat/publish.yml?style=flat-square&branch=dev)](https://github.com/dzshowrav/openchat/actions/workflows/publish.yml)

---

## ✨ Features

### Core AI Capabilities
- **Multi-provider LLM support** — OpenAI (GPT-4o, o-series), Anthropic (Claude 3.5/4 Sonnet/Opus), Google Gemini, Azure OpenAI, AWS Bedrock, GitHub Copilot, XAI Grok, DeepSeek, Together AI, OpenRouter, Ollama (local), and 30+ OpenAI-compatible providers
- **File operations** — read, write, edit, apply patches, search (grep/glob), move, delete files
- **Shell execution** — run bash commands in your project directory with full permission controls
- **Web search & fetch** — real-time internet access for up-to-date information
- **Git integration** — commit, diff, log, status, branch management via natural language
- **LSP integration** — language server diagnostics, symbol search, code navigation
- **Multi-file editing** — coordinated edits across large codebases
- **Code mode** — confined JavaScript/TypeScript sandbox execution

### Terminal UI (TUI)
- **Full-screen interactive chat interface** with split-pane layout
- **Command palette** — `Ctrl+K` for quick actions
- **Slash commands** — `/help`, `/exit`, `/uninstall`, `/clear`, and custom commands
- **Theming system** — 9 built-in themes (Catppuccin, Dracula, Nord, Tokyo Night, Solarized, One Dark, Gruvbox, Everforest, Kanagawa)
- **Dialog overlay stack** — alert, confirm, prompt, select, export, help dialogs
- **Toast notifications** — for long-running operations
- **Session scrollback** — review past assistant responses
- **Thinking indicator** — real-time streaming progress
- **Prompt history** — `Ctrl+R` reverse search through past prompts
- **Session timeline** — browse, resume, delete, fork past sessions

### Multi-Agent System
- **build** — default full-access agent for development work (can edit files, run commands)
- **plan** — read-only agent for code review, analysis, and exploration
- **Subagents** — spawn `@general` subagents for complex multi-step research
- **Custom agents** — define your own agents in `openchat.json`

### Platform Support
- **macOS** (Intel & Apple Silicon), **Linux**, **Windows** (via PowerShell), **Termux** (Android)
- **Desktop app** — Electron-based GUI for macOS, Windows, and Linux
- **Web app** — browser-based chat interface
- **Headless server** — HTTP API server for remote access and CI/CD integration
- **MCP server mode** — Model Context Protocol server for LLM tool integration

### Plugin System
- **V1 (Promise-based) plugins** — existing plugin ecosystem
- **V2 (Effect-based) plugins** — next-gen plugin architecture with hot-reload
- **Plugin catalog** — discover and install plugins from npm
- **TUI plugins** — extend the terminal UI with custom components

---

## 📦 Installation

### Quick Install (curl)

```bash
# Unix (macOS, Linux)
curl -fsSL https://openchat.ai/install | bash

# Android (Termux)
curl -fsSL https://raw.githubusercontent.com/dzshowrav/openchat/refs/heads/dev/install-termux.sh | bash
```

### Package Managers

```bash
# npm / bun / pnpm / yarn (latest stable)
npm install -g openchat-ai@latest

# macOS — Homebrew (recommended, always up to date)
brew install dzshowrav/tap/openchat

# macOS — Homebrew (official formula, updated less frequently)
brew install openchat

# Windows — Scoop
scoop install openchat

# Windows — Chocolatey
choco install openchat

# Arch Linux — Stable
sudo pacman -S openchat

# Arch Linux — Latest from AUR
paru -S openchat-bin

# Universal — mise
mise use -g openchat

# Nix
nix run nixpkgs#openchat
# or for latest dev branch:
nix run github:dzshowrav/openchat
```

### Desktop App (BETA)

OpenChat is also available as a desktop application:

| Platform | Download |
|---|---|
| macOS (Apple Silicon) | `openchat-desktop-mac-arm64.dmg` |
| macOS (Intel) | `openchat-desktop-mac-x64.dmg` |
| Windows | `openchat-desktop-windows-x64.exe` |
| Linux | `.deb`, `.rpm`, or `.AppImage` |

Download from the [releases page](https://github.com/dzshowrav/openchat/releases) or [openchat.ai/download](https://openchat.ai/download).

```bash
# macOS (Homebrew)
brew install --cask openchat-desktop

# Windows (Scoop)
scoop bucket add extras
scoop install extras/openchat-desktop
```

### Installation Directory

The install script respects this priority:
1. `$OPENCHAT_INSTALL_DIR` — custom installation directory
2. `$XDG_BIN_DIR` — XDG Base Directory Specification path
3. `$HOME/bin` — standard user binary directory
4. `$HOME/.openchat/bin` — default fallback

```bash
OPENCHAT_INSTALL_DIR=/usr/local/bin curl -fsSL https://openchat.ai/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://openchat.ai/install | bash
```

---

## 🚀 Quick Start

### Start a Session

```bash
# Open the TUI (default)
openchat

# Start in non-interactive mode with a prompt
openchat -p "Explain this codebase"

# Continue a previous session
openchat --continue
# or by session ID
openchat -s ses_07ca5401dffeDP8xOXOs2GU1o6

# Fork a previous session (branch from it)
openchat -s ses_previous_id --fork
```

### Usage Modes

| Command | Description |
|---|---|
| `openchat` | Full TUI (default) |
| `openchat --mini` | Minimal interactive mode (prompt only) |
| `openchat -p "prompt"` | Non-interactive: run prompt and exit |
| `openchat -p "prompt" | Non-interactive with stdin pipe |
| `openchat serve` | Start headless HTTP server |
| `openchat web` | Start web interface |
| `openchat mcp` | Run as MCP server |

### TUI Keybindings

| Key | Action |
|---|---|
| `Tab` | Switch between build/plan agents |
| `Ctrl+K` | Open command palette |
| `Ctrl+P` | Open session picker |
| `Ctrl+R` | Reverse-search prompt history |
| `Ctrl+L` | Clear scrollback |
| `Ctrl+D` | Toggle thinking indicator |
| `Ctrl+C` | Cancel current generation |
| `Escape` | Close dialog / cancel |
| `Enter` | Send prompt / confirm |
| `Up/Down` | Navigate history / options |

### Slash Commands

| Command | Description |
|---|---|
| `/help` | Show help information |
| `/clear` | Clear the scrollback |
| `/exit` | Exit OpenChat |
| `/uninstall` | Remove the `occ` wrapper and CLI |
| Custom | Commands from plugins or `openchat.json` |

---

## ⚙️ Configuration

### Providers & Models

OpenChat supports a wide range of AI providers. Configure which provider and model to use:

```bash
# Set provider via environment variable
export OPENCHAT_PROVIDER=openai

# Set API key
export OPENAI_API_KEY=sk-...
export ANTHROPIC_API_KEY=sk-ant-...

# Or use the providers command
openchat providers set
openchat models
```

**Supported providers:**

| Provider | Env Variable | Models |
|---|---|---|
| OpenAI | `OPENAI_API_KEY` | GPT-4o, o1, o3, GPT-4.1, GPT-4.1-mini |
| Anthropic | `ANTHROPIC_API_KEY` | Claude 4 Sonnet, Claude 4 Opus, Claude 3.5 Sonnet, Claude 3.5 Haiku |
| Google Gemini | `GEMINI_API_KEY` | Gemini 2.5 Pro, Gemini 2.5 Flash |
| Azure OpenAI | `AZURE_OPENAI_API_KEY` | All Azure-deployed models |
| AWS Bedrock | AWS credentials | Claude, Llama, Mistral via Bedrock |
| GitHub Copilot | `GITHUB_TOKEN` | GPT-4o, Claude Sonnet (Copilot models) |
| XAI Grok | `XAI_API_KEY` | Grok-2, Grok-3 |
| DeepSeek | `DEEPSEEK_API_KEY` | DeepSeek V3, DeepSeek R1 |
| Together AI | `TOGETHER_API_KEY` | 100+ open models |
| OpenRouter | `OPENROUTER_API_KEY` | 200+ models from all providers |
| Ollama | `OLLAMA_BASE_URL` | All local Ollama models |
| Cloudflare | `CLOUDFLARE_API_TOKEN` | Workers AI models |
| Snowflake Cortex | Snowflake credentials | Snowflake Cortex AI |
| DigitalOcean | `DIGITALOCEAN_TOKEN` | DO GPU models |
| GitLab | `GITLAB_API_TOKEN` | GitLab AI models |
| Poe | `POE_API_KEY` | Poe platform models |

### openchat.json

Create an `openchat.json` in your project root for custom configuration:

```json
{
  "provider": {
    "model": "claude-sonnet-4-20250514"
  },
  "agent": {
    "build": {
      "permissions": {
        "allow": ["read", "write", "edit", "bash", "grep", "glob"]
      }
    },
    "plan": {
      "permissions": {
        "deny": ["write", "edit", "bash"]
      }
    }
  },
  "plugins": [
    {
      "name": "my-plugin",
      "path": "./plugins/my-plugin.js"
    }
  ],
  "commands": [
    {
      "name": "deploy",
      "description": "Deploy to production",
      "prompt": "Run the deployment process for this project"
    }
  ],
  "experimental": {
    "backgroundSubagents": true,
    "toolCallParsingStrict": true
  },
  "formatters": [
    {
      "pattern": "*.ts",
      "command": "bun run format"
    }
  ]
}
```

---

## 🏗️ Project Architecture

OpenChat is organized as a **Bun monorepo** with **30+ packages** under `packages/`.

```
opc/
├── packages/
│   ├── openchat/        # Main CLI application & TUI runtime
│   ├── core/            # Domain logic & Effect services (@openchat-ai/core)
│   ├── tui/             # Terminal UI (SolidJS + OpenTUI)
│   ├── llm/             # LLM abstraction layer (@openchat-ai/llm)
│   ├── schema/          # Wire contracts & storage schemas (@openchat-ai/schema)
│   ├── protocol/        # HTTP API protocol definitions
│   ├── server/          # HTTP server implementation
│   ├── client/          # Auto-generated HTTP client
│   ├── sdk-next/        # Next-gen in-process SDK
│   ├── sdk/             # Legacy JavaScript SDK
│   ├── plugin/          # Plugin SDK (V1 Promise + V2 Effect)
│   ├── ui/              # Shared web UI components
│   ├── app/             # Desktop/Web application (Electron + SolidJS)
│   ├── web/             # Public website (Astro + Starlight)
│   ├── codemode/        # Sandboxed JS/TS execution
│   ├── containers/      # Containerized tool execution
│   ├── slack/           # Slack integration
│   ├── docs/            # Documentation site
│   ├── stats/           # Usage statistics
│   └── ...              # 15+ more packages
├── specs/               # Design specifications
├── script/              # Build & utility scripts
├── sdks/                # Generated SDK artifacts
├── infra/               # Infrastructure (SST)
├── patches/             # Dependency patches
└── nix/                 # Nix packaging
```

### Dependency Flow

```
Schema → Core → Protocol → Server
       ↘ Client → SDK
Plugin → (independent)
   TUI → Core + Plugin + SDK
```

- **Schema** — zero runtime dependencies (Effect-only). Defines all domain types.
- **Core** — domain backbone. All business logic, database, tools, sessions, config, permissions, providers.
- **Protocol** — HTTP API route definitions (no runtime imports).
- **Server** — concrete HTTP server (Protocol + Core).
- **Client** — auto-generated HTTP client (Schema + Protocol only).
- **TUI** — SolidJS terminal UI (Core + Plugin + SDK).

### Key Architectural Layers

#### Session V2 (Durable Sessions)
- Sessions are persisted via SQLite + Drizzle ORM
- `SessionV2.prompt(...)` admits a durable input row before scheduling execution
- `SessionExecution` is process-global, session-ID based
- `SessionRunner` is Location-scoped (model resolution, tool registry, permissions)
- Context epochs manage system prompt caching boundaries
- Delivery modes: `steer` (default, promotes at next provider turn), `queue` (promotes at idle boundary)

#### Tool System
- Canonical `Tool.make(...)` with typed Effect Schema input/output
- Built-in tools: `bash`, `edit`, `write`, `read`, `grep`, `glob`, `websearch`, `webfetch`, `apply_patch`, `question`, `skill`, `todo`, `task`, `lsp`, `plan`, `truncate`
- Tool Registry is Location-scoped with process-scoped application tool overrides
- Permission controls per agent (allow/deny individual tools)

#### Plugin System (V2)
- Effect-based services with add/remove lifecycle and hot-reload
- Plugin types: agent, command, context, event, filesystem, integration, location, npm, reference, skill
- Plugin catalog with npm discovery

#### Config System
- Multi-source merge: JSON files, remote URLs, environment variables
- Array concatenation strategy
- Supports `openchat.json` (V1) and migrating to V2

---

## 🖥️ Commands

### General Commands

| Command | Description |
|---|---|
| `openchat` | Start the TUI (default) |
| `openchat -p "text"` | Run a prompt and exit |
| `openchat --mini` | Start minimal interactive mode |
| `openchat --continue` | Resume last session |
| `openchat -s <id>` | Resume a specific session |
| `openchat --fork` | Fork a session on resume |

### CLI Subcommands

| Command | Description |
|---|---|
| `openchat serve` | Start headless HTTP server |
| `openchat web` | Start web interface |
| `openchat mcp` | Run as MCP server |
| `openchat acp` | Agent-to-agent communication |
| `openchat generate` | Generate code from templates |
| `openchat debug` | Debug utilities |
| `openchat account` | Account management |
| `openchat providers` | Provider configuration |
| `openchat agent` | Agent management |
| `openchat models` | List available models |
| `openchat upgrade` | Upgrade OpenChat |
| `openchat uninstall` | Uninstall OpenChat |
| `openchat session` | Session management |
| `openchat plugin` | Plugin management |
| `openchat export` | Export session data |
| `openchat import` | Import session data |
| `openchat github` | GitHub integration |
| `openchat pr` | Pull request management |
| `openchat stats` | Usage statistics |
| `openchat db` | Database management |
| `openchat completion` | Shell completion generation |
| `openchat help` | Show help |

### Global Flags

| Flag | Description |
|---|---|
| `--print-logs` | Print debug logs to stderr |
| `--log-level <level>` | Set log level (debug, info, warn, error) |
| `--pure` | Run without external plugins |

---

## 🔧 Development

### Prerequisites

- **Bun** 1.2.x+ — [install bun](https://bun.sh)
- **Node.js** 22+ (optional, for some tooling)

### Setup

```bash
# Clone the repository
git clone https://github.com/dzshowrav/openchat.git
cd openchat

# Install dependencies
bun install

# Build packages
bun run build
```

### Development Workflow

```bash
# Run TUI in development mode
cd packages/openchat
bun run dev

# Run tests
bun run test

# Type check
bun run typecheck

# Generate client SDK (after changing Protocol)
cd packages/client
bun run generate

# Regenerate legacy JS SDK
./packages/sdk/js/script/build.ts
```

### Project Conventions

- **Branch names**: short, 3 words max, hyphen-separated (e.g., `session-recovery`)
- **Commit messages**: conventional format — `type(scope): summary` (types: feat, fix, docs, chore, refactor, test)
- **Style**:
  - Prefer `const` over `let`, early returns over `else`
  - No aliased or star imports
  - No explicit types when inference works
  - Functional array methods over for loops
  - No `try/catch` where avoidable
  - No `any` type
- **Testing**: run from package directories, not repo root
- **Type checking**: use `bun typecheck` from package directories

---

## 🎨 Theme System

OpenChat includes 9 built-in themes for the TUI:

| Theme | Description |
|---|---|
| **Catppuccin Mocha** | Dark, warm purple-based (default) |
| **Dracula** | Dark, purple/cyan accents |
| **Nord** | Arctic, blue-gray |
| **Tokyo Night** | Dark blue/purple |
| **Solarized Dark** | Warm dark amber |
| **One Dark** | Atom-inspired dark |
| **Gruvbox** | Retro dark |
| **Everforest** | Green-tinted dark |
| **Kanagawa** | Japanese ink wash-inspired |

Switch themes in the TUI via the command palette (`Ctrl+K` → search "theme").

---

## 🤝 Plugin Development

Plugins extend OpenChat with custom tools, providers, commands, and UI components.

### V2 Plugin (Effect-based)

```typescript
import { PluginV2 } from "@openchat-ai/plugin/v2/effect"
import { Effect, Layer } from "effect"

const MyPlugin = PluginV2.make({
  name: "my-plugin",
  version: "1.0.0",
  setup: Effect.gen(function* () {
    // Register tools, commands, or context providers
  }),
  cleanup: Effect.gen(function* () {
    // Teardown logic
  }),
})
```

### V1 Plugin (Promise-based)

```javascript
export default {
  name: "my-plugin",
  async setup(context) {
    // context: { tools, commands, events, config }
    context.tools.register({
      name: "my-tool",
      description: "My custom tool",
      execute: async (input) => {
        return { result: "hello from my plugin" }
      },
    })
  },
}
```

---

## 🌐 Server Mode

OpenChat can run as a headless HTTP server with a full REST + WebSocket API.

```bash
# Start the server
openchat serve --port 8080

# With mDNS discovery
openchat serve --mdns

# Enable CORS for web clients
openchat serve --cors http://localhost:5173
```

The server implements the full `HttpApi` protocol with endpoints for sessions, messages, agents, models, providers, filesystem operations, permissions, and more.

---

## 📱 Termux (Android) Support

OpenChat works on Android via Termux:

```bash
# Install in Termux
curl -fsSL https://raw.githubusercontent.com/dzshowrav/openchat/refs/heads/dev/install-termux.sh | bash

# Or from the repo
./install-termux.sh
```

Note: Some features (e.g., Turbo repo builds, desktop integration) may not be available on Android.

---

## 🔒 Permissions System

OpenChat implements a granular permission model for safety:

- **Agent-level permissions** — each agent has its own set of allowed/denied tools
- **Tool-level permissions** — `allow`, `deny`, and `ask` (default) for each tool
- **Auto-approve mode** — `--yolo` / `--auto` for non-interactive usage (dangerous!)
- **Host tool restriction** — certain tools are host-restricted (cannot be overridden by config)

### Default Permissions

| Tool | build | plan |
|---|---|---|
| read | ✅ allow | ✅ allow |
| write | ✅ allow | ❌ deny |
| edit | ✅ allow | ❌ deny |
| apply_patch | ✅ allow | ❌ deny |
| bash | ✅ allow | ⚠️ ask |
| grep | ✅ allow | ✅ allow |
| glob | ✅ allow | ✅ allow |
| websearch | ✅ allow | ✅ allow |
| webfetch | ✅ allow | ✅ allow |
| question | ✅ allow | ✅ allow |
| task | ✅ allow | ✅ allow |

---

## 📄 License

This project is licensed under the MIT License — see the LICENSE file for details.

Based on [opencode](https://github.com/anomalyco/opencode), the open-source version of Anthropic's Claude Code CLI.

---

## 🙏 Acknowledgements

- [Anthropic](https://anthropic.com) for Claude and the original Claude Code
- [anomalyco](https://github.com/anomalyco) for the opencode project
- [Effect](https://effect.website) for the functional effect system
- [SolidJS](https://solidjs.com) for reactive UI
- [OpenTUI](https://github.com/sst/opentui) for terminal UI framework
- [Bun](https://bun.sh) for the fast JavaScript runtime

---

## 🆘 Support

- **Discord**: [openchat.ai/discord](https://openchat.ai/discord)
- **Issues**: [GitHub Issues](https://github.com/dzshowrav/openchat/issues)
- **Website**: [openchat.ai](https://openchat.ai)
