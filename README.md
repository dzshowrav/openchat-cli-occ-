# OpenChat — AI Development Tool for Termux

OpenChat is a full-featured AI-powered development assistant that runs entirely inside **Termux** on Android. It provides an interactive terminal UI (TUI) for chatting with AI models from multiple providers, managing sessions, generating code, and controlling your development workflow — all without leaving the terminal.

**Version:** 1.18.4 | **License:** MIT | **Runtime:** Bun 1.3.14

---

## Table of Contents

- [What is OpenChat?](#what-is-openchat)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Install](#quick-install)
  - [Manual Installation](#manual-installation)
  - [Verification](#verification)
- [The `occ` Command](#the-occ-command)
- [How It Works](#how-it-works)
- [CLI Commands Reference](#cli-commands-reference)
- [First Run — Starting the TUI](#first-run--starting-the-tui)
- [Configuration](#configuration)
- [AI Providers Setup](#ai-providers-setup)
- [Managing Sessions](#managing-sessions)
- [Updating OpenChat](#updating-openchat)
- [Uninstalling](#uninstalling)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [Frequently Asked Questions](#frequently-asked-questions)

---

## What is OpenChat?

OpenChat is an AI coding assistant that runs as a **terminal UI (TUI)** inside Termux. It connects to various AI model providers (OpenAI, Anthropic, Google, Groq, Mistral, and many more) and lets you:

- Chat with AI models interactively
- Generate and edit code files
- Run shell commands through the AI
- Manage multiple chat sessions with history
- Use slash commands for common operations
- Work with Git, GitHub, and MCP servers
- Export and import sessions

Unlike cloud-based IDEs or web UIs, OpenChat runs fully inside your Termux environment with no external dependencies beyond a Bun runtime and network access to your chosen AI provider.

---

## Prerequisites

Before installing OpenChat, ensure your Termux environment has:

| Requirement | Details |
|---|---|
| **Termux** | Latest version from F-Droid (recommended) or GitHub. **Do not use the Play Store version** — it is outdated. |
| **Storage** | ~500 MB free for the repo + dependencies |
| **RAM** | Minimum 2 GB recommended (4 GB+ for larger models) |
| **Network** | Internet connection for AI provider API calls |
| **Git** | `pkg install git` |
| **Bun** | Installed automatically by the install script (see below) |

### Recommended Termux Packages

```bash
pkg update && pkg upgrade
pkg install git curl which ncurses-utils
```

> **Note:** OpenChat works with **both** `bash` and `zsh`. The install script auto-detects your shell.

---

## Installation

### Quick Install

Run this single command in Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/dzshowrav/openchat-cli-occ-/main/install-termux.sh | bash
```

The script will:
1. Install **Bun** (if not already installed)
2. Clone the OpenChat repository to `~/opc`
3. Run `bun install` to install all dependencies
4. Create the `occ` wrapper at `~/.local/bin/occ`
5. Add `~/.local/bin` to your `PATH` (in `~/.bashrc` or `~/.zshenv`)
6. Print a success message

After installation, **restart Termux** or run `source ~/.bashrc` (or `source ~/.zshenv` for zsh).

### Manual Installation

If you prefer to install step by step:

```bash
# 1. Install Bun
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc

# 2. Clone the repository
git clone https://github.com/dzshowrav/openchat-cli-occ- ~/opc

# 3. Install dependencies
cd ~/opc
bun install

# 4. Create the occ wrapper
mkdir -p ~/.local/bin
cat > ~/.local/bin/occ << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
if [ $# -eq 0 ]; then
  exec bun run --cwd "$HOME/opc/packages/openchat" --conditions=browser src/index.ts "$PWD"
else
  exec bun run --cwd "$HOME/opc/packages/openchat" --conditions=browser src/index.ts "$@"
fi
EOF
chmod +x ~/.local/bin/occ

# 5. Add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 6. Verify
occ --version
```

### Verification

After installation, verify everything works:

```bash
occ --version
# Should output: openchat version X.X.X

occ --help
# Should show the OpenChat logo and full help text

which occ
# Should show: /data/data/com.termux/files/home/.local/bin/occ
```

---

## The `occ` Command

`occ` is a shell wrapper script located at `~/.local/bin/occ`. It is the primary entry point for OpenChat.

### How the Wrapper Works

```bash
#!/data/data/com.termux/files/usr/bin/bash
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
if [ $# -eq 0 ]; then
  exec bun run --cwd "$HOME/opc/packages/openchat" --conditions=browser src/index.ts "$PWD"
else
  exec bun run --cwd "$HOME/opc/packages/openchat" --conditions=browser src/index.ts "$@"
fi
```

**Key details:**

| Aspect | Explanation |
|---|---|
| **`LD_PRELOAD`** | Required for proper `exec` behavior inside Termux. Without this, `bun` processes spawned by OpenChat may not work correctly. |
| **`--cwd`** | Changes to the `packages/openchat` directory so Bun can resolve JSX and module imports correctly (specifically `@opentui/solid/jsx-dev-runtime`). |
| **`--conditions=browser`** | Tells Bun to use browser-compatible module resolution, which is needed for SolidJS (the TUI framework). |
| **`$PWD` passthrough** | When called with no arguments, the wrapper passes the **current directory** as the project path. This means `occ` always opens the TUI in the directory you're standing in. |
| **No arguments = TUI** | Running `occ` without any arguments starts the full-screen interactive TUI in the current directory. |
| **Arguments = CLI mode** | Passing arguments (e.g., `occ --help`, `occ run`, `occ generate`) runs the corresponding CLI command. |

### Common Usage Patterns

```bash
# Start TUI in current directory
occ

# Start TUI in a specific project
occ ~/projects/my-app

# Show help
occ --help

# Check version
occ --version

# Run a generation command
occ generate

# Continue a specific session
occ -s ses_abc123
```

---

## How It Works

### Architecture Overview

OpenChat is a **monorepo** with 30+ packages. The core execution flow:

```
occ (wrapper)
  └── bun run src/index.ts (yargs CLI entry)
        ├── Starts internal HTTP server (for plugin/MCP communication)
        ├── Spawns a Web Worker for background tasks
        └── Runs the TUI renderer (SolidJS + OpenTUI)
              ├── Footer input bar (type prompts here)
              ├── Scrollback view (chat history)
              ├── Provider API calls (via @ai-sdk/*)
              └── Session persistence (SQLite via Drizzle ORM)
```

**Key Components:**

| Component | Package | Role |
|---|---|---|
| **CLI Entry** | `packages/openchat` | Yargs-based CLI, command routing, TUI thread management |
| **TUI Framework** | `packages/tui` | SolidJS-based terminal UI (split pane, scrollback, footer, dialogs, themes) |
| **Core Engine** | `packages/core` | Session management, prompt routing, tool execution, Effect service layer |
| **AI SDK** | `packages/llm` | AI provider abstraction (unified API across 15+ providers) |
| **Protocol** | `packages/protocol` | Agent-Client Protocol (ACP) and Model Context Protocol (MCP) |
| **Server** | `packages/server` | Internal HTTP server for MCP, plugins, and web access |
| **Schema** | `packages/schema` | Data types, validation, and serialization |
| **Plugin System** | `packages/plugin` | Third-party plugin host and runtime |
| **SDK** | `packages/sdk` | Client SDK for programmatic access |

### Technology Stack

| Technology | Purpose |
|---|---|
| **Bun** | JavaScript runtime (faster than Node.js) |
| **TypeScript** | All code is TypeScript |
| **Effect** | Functional effect system for service orchestration, error handling, and concurrency |
| **SolidJS** | Reactive UI framework for the terminal interface |
| **OpenTUI** | Terminal UI component library (built on Bubble Tea philosophy) |
| **Yargs** | CLI argument parsing |
| **Drizzle ORM** | SQLite database for session persistence |
| **@ai-sdk/** | Provider SDKs for 15+ AI model providers |
| **tree-sitter** | Code parsing and syntax understanding |

---

## CLI Commands Reference

OpenChat provides 20+ commands. Here is the complete reference:

### Global Options

These options work with **any** command:

| Option | Alias | Description |
|---|---|---|
| `--version` | `-v` | Show version number |
| `--help` | `-h` | Show help |
| `--print-logs` | | Print internal logs to stdout |
| `--log-level` | | Set log level: `DEBUG`, `INFO`, `WARN`, `ERROR` |
| `--pure` | | Run without external plugins |
| `completion` | | Generate shell completion script |

### Commands

| Command | Description |
|---|---|
| **`$0`** (default) | Start the interactive TUI in the current directory. This is what `occ` runs with no arguments. |
| **`run`** | Start the TUI in **mini mode** (minimal interface, no split pane). Run `occ run --help` for options. |
| **`generate`** | Generate code or files using AI. |
| **`account`** | Manage your OpenChat account and settings. |
| **`providers`** | List and configure AI model providers. |
| **`agent`** | Create and manage AI agents. |
| **`models`** | List available AI models. |
| **`session`** | Manage chat sessions (list, view, delete). |
| **`serve`** | Start OpenChat in server mode (HTTP API). |
| **`web`** | Start the web interface. |
| **`mcp`** | Model Context Protocol server management. |
| **`github`** | GitHub integration (PRs, issues, repos). |
| **`pr`** | Pull request management. |
| **`export`** | Export sessions to file. |
| **`import`** | Import sessions from file. |
| **`upgrade`** | Update OpenChat to the latest version. |
| **`uninstall`** | Remove OpenChat from the system. |
| **`stats`** | View usage statistics. |
| **`debug`** | Debugging tools (config, file, LSP, snapshot, etc.). Has 12 subcommands. |
| **`attach`** | Attach to a running OpenChat process. |
| **`acp`** | Agent-Client Protocol commands. |
| **`db`** | Database management. |
| **`plug`** | Plugin management. |

### TUI-Specific Options

When running `occ` (the default TUI command), these options are available:

| Option | Alias | Description |
|---|---|---|
| `--model` | `-m` | Specify model in format `provider/model` |
| `--continue` | `-c` | Continue the last session |
| `--session` | `-s` | Continue a specific session by ID |
| `--fork` | | Fork the session when continuing (use with `--continue` or `--session`) |
| `--prompt` | | Initial prompt to send |
| `--agent` | | Agent to use |
| `--auto` | | Auto-approve permissions not explicitly denied |
| `--mini` | | Start minimal interface instead of full TUI |
| `--no-replay` | | Disable mini session history replay on resume |
| `--replay-limit` | | Cap visible mini replay to the newest N messages |

### Example Commands

```bash
# Start TUI in current project
occ

# Start TUI with a specific model
occ -m anthropic/claude-sonnet-4-20250514

# Continue the last session
occ -c

# Continue a specific session
occ -s ses_abc123

# Fork a session (create new branch from existing)
occ -c --fork

# Start with a prompt
occ --prompt "Refactor this codebase to use Effect"

# Start in mini mode
occ --mini

# Run a generation task
occ generate "Create a React component for a data table"

# List all sessions
occ session list
```

---

## First Run — Starting the TUI

After installation, simply run:

```bash
occ
```

This will:
1. Display the OpenChat logo and banner
2. Start the internal server
3. Launch the full-screen TUI
4. Show a welcome message with session info

### TUI Layout

The TUI has a **split-pane layout**:

```
┌──────────────────────────────────────────────┐
│  Logo / Banner                               │
│                                              │
│  ┌──────────────────┬──────────────────────┐ │
│  │                  │                      │ │
│  │  Chat History    │  Preview / Code      │ │
│  │  (Scrollback)    │  (Editor)            │ │
│  │                  │                      │ │
│  │                  │                      │ │
│  └──────────────────┴──────────────────────┘ │
│                                              │
│  > Type your prompt here...         [Send]   │
│  ──────────────────────────────────────────  │
│  Status bar / Controls                      │
└──────────────────────────────────────────────┘
```

### Basic TUI Controls

| Key | Action |
|---|---|
| **Type & Enter** | Send a prompt to the AI |
| **Ctrl+C** | Cancel current generation |
| **Tab** | Focus next pane |
| **Shift+Tab** | Focus previous pane |
| **Ctrl+P** | Command palette |
| **Ctrl+N** | New session |
| **Ctrl+D** | Toggle dark/light mode |
| **Ctrl+W** | Close pane |
| **Ctrl+Q** | Quit |
| **/** | Focus search |
| **Escape** | Close dialog / cancel |

### Slash Commands

Type `/` in the prompt to see available slash commands:

| Command | Action |
|---|---|
| `/exit` | Exit OpenChat |
| `/clear` | Clear scrollback |
| `/session` | Session management |
| `/model` | Switch model |
| `/agent` | Switch agent |
| `/help` | Show help |
| `/uninstall` | Remove occ wrapper files |

---

## Configuration

OpenChat stores configuration in the OpenChat config directory (created automatically on first run).

### Config Location

```
~/.config/openchat/
├── config.json         # Main configuration
├── providers.json      # Provider API keys and settings
├── keybind.json        # Custom keybindings
├── theme.json          # Theme settings
└── sessions.db         # SQLite database for sessions
```

### Key Configuration Options

OpenChat uses a JSON-based configuration system. Key settings include:

```json
{
  "theme": "catppuccin-mocha",
  "model": "anthropic/claude-sonnet-4-20250514",
  "providers": {
    "anthropic": { "apiKey": "sk-ant-..." },
    "openai": { "apiKey": "sk-..." }
  },
  "autoApprove": false,
  "replayLimit": 50
}
```

### Available Themes

The TUI ships with multiple built-in themes including Catppuccin (mocha, macchiato, frappe, latte), Dracula, Nord, Tokyo Night, and more. Themes can be cycled with `Ctrl+D`.

---

## AI Providers Setup

OpenChat supports 15+ AI providers out of the box. You need at least **one API key** to use the tool.

### Supported Providers

| Provider | Package | Setup |
|---|---|---|
| **Anthropic (Claude)** | `@ai-sdk/anthropic` | Set `ANTHROPIC_API_KEY` env var or configure in providers |
| **OpenAI (GPT)** | `@ai-sdk/openai` | Set `OPENAI_API_KEY` env var |
| **Google (Gemini)** | `@ai-sdk/google` | Set `GOOGLE_GENERATIVE_AI_API_KEY` env var |
| **Groq** | `@ai-sdk/groq` | Set `GROQ_API_KEY` env var |
| **Mistral** | `@ai-sdk/mistral` | Set `MISTRAL_API_KEY` env var |
| **Perplexity** | `@ai-sdk/perplexity` | Set `PERPLEXITY_API_KEY` env var |
| **xAI (Grok)** | `@ai-sdk/xai` | Set `XAI_API_KEY` env var |
| **Cohere** | `@ai-sdk/cohere` | Set `COHERE_API_KEY` env var |
| **Cerebras** | `@ai-sdk/cerebras` | Set `CEREBRAS_API_KEY` env var |
| **DeepInfra** | `@ai-sdk/deepinfra` | Set `DEEPINFRA_API_KEY` env var |
| **Together AI** | `@ai-sdk/togetherai` | Set `TOGETHER_API_KEY` env var |
| **Alibaba (Qwen)** | `@ai-sdk/alibaba` | Set `ALIBABA_API_KEY` env var |
| **OpenRouter** | `@openrouter/ai-sdk-provider` | Set `OPENROUTER_API_KEY` env var |
| **Venice AI** | `venice-ai-sdk-provider` | Set `VENICE_API_KEY` env var |
| **Azure OpenAI** | `@ai-sdk/azure` | Azure endpoint + key |
| **AWS Bedrock** | `@ai-sdk/amazon-bedrock` | AWS credentials |

### Setting Up API Keys

**Method 1: Environment Variables** (recommended)

Add to your `~/.bashrc` or `~/.zshenv`:

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
```

Then reload: `source ~/.bashrc`

**Method 2: Configuration File**

OpenChat creates a `providers.json` file on first run. You can edit it to add keys.

**Method 3: TUI Provider Command**

From the command line:
```bash
occ providers
```

### Selecting a Model

In the TUI:
1. Press `Ctrl+P` to open the command palette
2. Search for "model" or "switch model"
3. Select from the list of configured providers

Or from CLI:
```bash
occ -m anthropic/claude-sonnet-4-20250514
```

---

## Managing Sessions

OpenChat automatically creates a **new session** each time you start the TUI (unless you use `--continue` or `--session`).

### Session Features

| Feature | Description |
|---|---|
| **Auto-save** | Every message is saved to SQLite automatically |
| **History replay** | On resume, previous messages are replayed in the scrollback |
| **Session listing** | View all sessions with `occ session list` |
| **Continue** | Resume a session with `occ -s <session_id>` or `occ -c` (last session) |
| **Forking** | Create a branch from an existing session with `--fork` |
| **Export/Import** | Sessions can be exported to JSON and imported back |

### Session ID Format

```
ses_<timestamp><random>
```

Example: `ses_07ca5401dffeDP8xOXOs2GU1o6`

### CLI Session Commands

```bash
# List all sessions
occ session list

# View session details
occ session show <session_id>

# Delete a session
occ session delete <session_id>

# Continue the last session
occ -c

# Continue a specific session
occ -s ses_abc123

# Fork a session
occ -c --fork
```

---

## Updating OpenChat

The repository is on the `main` branch (configured for active development).  
Updates are **source-based** — the `occ` wrapper always runs the current source in `~/opc`.  
You never need to reinstall from scratch; just sync the source and dependencies.

### Update Command

```bash
occ upgrade
```

This pulls the latest changes from the GitHub repository and re-runs `bun install`.

### Manual Update (recommended)

```bash
cd ~/opc
git pull
bun install
```

That is all. The `occ` wrapper stays untouched — it always executes `bun run src/index.ts` from the openchat package, so a source update is sufficient.

### Checking Version

```bash
occ --version
# or
occ -v
```

---

## Uninstalling

OpenChat provides two uninstall mechanisms:

### Method 1: In-App (from TUI)

While in the TUI, type:

```
/uninstall
```

This removes `~/.local/bin/occ` and `~/.local/bin/occ-install` at runtime.

### Method 2: CLI Command

```bash
occ uninstall
```

This performs a full package uninstall.

### Method 3: Manual

```bash
# Remove the occ wrapper
rm ~/.local/bin/occ ~/.local/bin/occ-install

# Remove the repository
rm -rf ~/opc

# Remove configuration (optional)
rm -rf ~/.config/openchat

# Remove from PATH (edit ~/.bashrc or ~/.zshenv)
# Remove the line: export PATH="$HOME/.local/bin:$PATH"
```

---

## Project Structure

The repository is a **Bun monorepo** with workspaces. Key directories:

```
~/opc/
├── AGENTS.md                    # AI agent rules and coding conventions
├── CONTRIBUTING.md              # Contribution guidelines
├── CONTEXT.md                   # Project context for AI agents
├── bun.lock                     # Bun lockfile
├── bunfig.toml                  # Bun configuration
├── package.json                 # Root package.json (workspaces)
├── tsconfig.json                # TypeScript configuration
├── turbo.json                   # Turbo repo configuration
├── install                      # Desktop installer script
├── install-termux.sh            # Termux installer script
│
├── packages/
│   ├── openchat/                # Main CLI entry point
│   │   └── src/
│   │       ├── index.ts         # CLI entry (yargs)
│   │       ├── cli/
│   │       │   ├── cmd/         # All CLI commands (20+ files)
│   │       │   │   ├── run/     # TUI runtime (37 files)
│   │       │   │   ├── debug/   # Debug subcommands
│   │       │   │   ├── tui.ts   # TUI thread handler
│   │       │   │   └── ...
│   │       │   ├── ui.ts        # Terminal output helpers
│   │       │   └── tui/         # TUI worker
│   │       ├── config/          # Configuration modules
│   │       ├── effect/          # Effect service layer
│   │       ├── plugin/          # Plugin host runtime
│   │       ├── project/         # Project/instance management
│   │       ├── server/          # Server management
│   │       └── util/            # Utilities
│   │
│   ├── tui/                     # TUI framework (SolidJS + OpenTUI)
│   │   └── src/
│   │       ├── app.tsx          # Main TUI app component
│   │       ├── routes/session/  # Session view (chat UI)
│   │       ├── component/       # UI components
│   │       ├── context/         # SolidJS context providers
│   │       └── util/            # Utilities
│   │
│   ├── core/                    # Core engine
│   ├── server/                  # HTTP server
│   ├── protocol/                # ACP + MCP protocols
│   ├── schema/                  # Data schema
│   ├── sdk/                     # Client SDK
│   ├── plugin/                  # Plugin system
│   ├── llm/                     # AI provider abstraction
│   ├── codemode/                # Code generation mode
│   ├── client/                  # API client
│   ├── web/                     # Web interface
│   ├── app/                     # Web app
│   └── ... (more packages)
│
├── script/                      # Build scripts
├── specs/                       # Specifications and docs
├── infra/                       # Infrastructure configs
├── nix/                         # Nix flake support
└── sdks/                        # Third-party SDKs
```

---

## Troubleshooting

### Common Issues

#### Issue: `bun: command not found`

**Solution:** Bun was not installed or PATH not updated.

```bash
curl -fsSL https://bun.sh/install | bash
export PATH="$HOME/.bun/bin:$PATH"
# Add to ~/.bashrc: echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
```

#### Issue: `occ: command not found`

**Solution:** `~/.local/bin` is not in your PATH.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Issue: `LD_PRELOAD` errors

**Solution:** Ensure `libtermux-exec` is installed.

```bash
pkg install termux-exec
```

#### Issue: TUI shows garbled characters

**Solution:** Your terminal may not support UTF-8 or the required Unicode characters. Ensure you are using a modern Termux build (from F-Droid) with a Unicode-compatible font.

#### Issue: `bun install` fails

**Solution:** Try cleaning and retrying.

```bash
cd ~/opc
rm -rf node_modules
bun install --no-cache
```

#### Issue: Provider API errors

**Solution:** Check that your API key is set correctly.

```bash
echo $ANTHROPIC_API_KEY  # Should show your key
```

If not set, add to `~/.bashrc` and run `source ~/.bashrc`.

#### Issue: Session not found

```bash
occ session list  # See all available sessions
occ -s <exact_session_id>  # Use exact ID
```

#### Issue: Out of memory

**Solution:** Close other apps or use a smaller model. Models like `claude-sonnet` require less memory than `claude-opus`.

### Debug Mode

For detailed troubleshooting, enable debug logging:

```bash
occ --log-level DEBUG
# or
OPENCHAT_LOG_LEVEL=DEBUG occ
```

### Getting Help

If you encounter issues not covered here:

1. Run `occ --help` for CLI usage
2. Check the `/help` slash command inside the TUI
3. Open an issue on GitHub: https://github.com/dzshowrav/openchat-cli-occ-/issues

---

## Frequently Asked Questions

### Does OpenChat work without internet?

No. OpenChat requires internet access to make API calls to AI providers. The TUI itself works offline, but no AI responses will be generated.

### Can I use OpenChat with local models?

OpenChat connects to remote API providers. Local model support depends on the provider — services like Ollama can be used via OpenAI-compatible endpoints.

### Are my API keys stored securely?

API keys can be set as environment variables (not stored on disk) or stored in the configuration file. The config file is in your home directory with standard file permissions.

### Can I run multiple sessions simultaneously?

Yes. Each `occ` invocation creates a new session. You can run multiple instances in different terminal sessions.

### Does OpenChat support image analysis?

Yes, for providers that support multimodal inputs (Claude, GPT-4V, Gemini), you can include images in your prompts.

### Can OpenChat execute shell commands?

Yes. OpenChat can execute shell commands in your Termux environment when the AI requests it. You will be prompted for approval unless `--auto` is enabled.

### How do I contribute?

See `CONTRIBUTING.md` in the repository root. The project follows conventional commit style (`type(scope): summary`) with types `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.

### What is the difference between `occ` and `openchat`?

`occ` is the shorthand command. `openchat` is the full command name. Both refer to the same tool.

---

*OpenChat v1.18.4 — Built with Bun, TypeScript, Effect, and SolidJS*
