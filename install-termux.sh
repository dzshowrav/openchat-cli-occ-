#!/data/data/com.termux/files/usr/bin/bash
set -e

REPO_URL="https://github.com/dzshowrav/openchat-cli-occ-.git"
INSTALL_DIR="${OPENCHAT_INSTALL_DIR:-$HOME/opc}"
BUN_DIR="$HOME/.bun"
BIN_DIR="$HOME/.local/bin"
LOG_FILE="/tmp/opc-install.log"

RED=$'\e[1;31m'; GREEN=$'\e[1;32m'; YELLOW=$'\e[1;33m'
BLUE=$'\e[1;34m'; CYAN=$'\e[1;36m'; WHITE=$'\e[1;37m'
DIM=$'\e[2m'; BOLD=$'\e[1m'; RESET=$'\e[0m'; CLR=$'\e[2K\r'

spinner() {
  local pid=$1 msg=$2 chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏' i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "  ${CYAN}%s${RESET}  %s" "${chars:i++%${#chars}:1}" "$msg"
    sleep 0.08
  done
  wait "$pid"; local rc=$?
  if [ $rc -eq 0 ]; then printf "${CLR}  ${GREEN}✓${RESET}  %s\n" "$msg"
  else printf "${CLR}  ${RED}✗${RESET}  %s\n" "$msg"; return $rc; fi
}

banner() {
  clear
  printf "${CYAN}"
  cat << 'EOF'
  ╔══════════════════════════════════════╗
  ║                                      ║
  ║     ╭━━━┳━━━┳━━━┳━━━┳━━━┳━━━┳━━━╮     ║
  ║     ┃   ┃   ┃   ┃   ┃   ┃   ┃   ┃     ║
  ║     ┃ O ┃ P ┃ E ┃ N ┃ C ┃ H ┃ A ┃     ║
  ║     ┃   ┃   ┃   ┃   ┃   ┃   ┃ T ┃     ║
  ║     ╰━━━┻━━━┻━━━┻━━━┻━━━┻━━━┻━━━╯     ║
  ║                                      ║
  ║     TERMUX INSTALLER v2.0            ║
  ║                                      ║
  ╚══════════════════════════════════════╝
EOF
  printf "${RESET}\n"
  printf "  ${DIM}Termux AI Coding Agent — Zero-to-Hero Setup${RESET}\n\n"
}

step() { printf "\n${BOLD}${BLUE}▸ %s${RESET}\n" "$1"; }

pkg_quiet() {
  pkg install -y "$@" > /dev/null 2>&1
}

main() {
  banner

  # ── Step 0: Termux check ──
  step "Checking environment"
  if [ ! -f /data/data/com.termux/files/usr/bin/pkg ]; then
    printf "  ${RED}✗${RESET}  This script is for Termux on Android only.\n"
    exit 1
  fi
  printf "  ${GREEN}✓${RESET}  Termux detected\n"
  printf "  ${DIM}  Architecture: $(uname -m)${RESET}\n"
  printf "  ${DIM}  Storage: ~%s free${RESET}\n" "$(df -h "$HOME" | awk 'NR==2{print $4}')"

  # ── Step 1: pkg update + base deps ──
  step "Updating package lists"
  (
    pkg update -y > /dev/null 2>&1
  ) &
  spinner $! "Refreshing Termux package mirrors..."
  printf "  ${DIM}  Mirrors updated${RESET}\n"

  step "Installing system packages"
  local base_pkgs="termux-exec git curl ca-certificates binutils"
  (
    pkg_quiet $base_pkgs
  ) &
  spinner $! "Installing: git, curl, ca-certificates, termux-exec..."
  
  # ── Step 2: Bun ──
  step "Installing Bun"
  local bun_installed=0
  
  if command -v bun >/dev/null 2>&1; then
    if bun --version > /dev/null 2>&1; then
      printf "  ${GREEN}✓${RESET}  Bun $(bun --version) found\n"
      bun_installed=1
    else
      printf "  ${YELLOW}⚠${RESET}  Bun binary broken (glibc from bun.sh) — fixing\n"
      mv "$BUN_DIR/bin/bun" "$BUN_DIR/bin/bun.broken.glibc" 2>/dev/null || true
    fi
  fi
  
  if [ $bun_installed -eq 0 ]; then
    (
      # Add termuxvoid repo for bun if needed
      if ! grep -q termuxvoid $PREFIX/etc/apt/sources.list 2>/dev/null; then
        echo "deb https://termuxvoid.github.io/repo termuxvoid main" >> "$PREFIX/etc/apt/sources.list"
      fi
      pkg update -y > /dev/null 2>&1
      pkg_quiet bun
    ) &
    spinner $! "Installing Bun from Termux repo..."
    # verify
    if ! bun --version > /dev/null 2>&1; then
      printf "  ${RED}✗${RESET}  Bun installation failed.\n"
      printf "  ${YELLOW}⚠${RESET}  Try manually: pkg install bun\n"
      exit 1
    fi
    printf "  ${GREEN}✓${RESET}  Bun $(bun --version) installed\n"
  fi

  # Clean up any broken glibc bun from bun.sh that might shadow Termux bun
  if [ -f "$BUN_DIR/bin/bun" ] && ! bun --version > /dev/null 2>&1; then
    mv "$BUN_DIR/bin/bun" "$BUN_DIR/bin/bun.broken.glibc" 2>/dev/null || true
    hash -r 2>/dev/null
  fi

  # ── Step 3: Node.js ──
  step "Installing Node.js"
  if command -v node >/dev/null 2>&1; then
    printf "  ${GREEN}✓${RESET}  Node.js $(node --version) found\n"
  else
    (
      pkg_quiet nodejs
    ) &
    spinner $! "Installing Node.js (needed for protobufjs)..."
    printf "  ${GREEN}✓${RESET}  Node.js $(node --version) installed\n"
  fi

  # ── Step 4: Clone repo ──
  step "Downloading OpenChat"
  if [ -d "$INSTALL_DIR/.git" ]; then
    (
      cd "$INSTALL_DIR" && git pull --ff-only > /dev/null 2>&1
    ) &
    spinner $! "Updating existing installation..."
  else
    (
      git clone --depth=1 "$REPO_URL" "$INSTALL_DIR" > /dev/null 2>&1
    ) &
    spinner $! "Cloning OpenChat repository..."
  fi

  # ── Step 5: bun install ──
  step "Installing JavaScript dependencies"
  (
    cd "$INSTALL_DIR"
    export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
    bun install > "$LOG_FILE" 2>&1
  ) &
  spinner $! "Resolving and installing packages (471 dependencies)..."
  local rc=$?
  if [ $rc -ne 0 ]; then
    printf "  ${RED}✗${RESET}  Package installation failed.\n"
    printf "  ${DIM}  Last 20 lines of log:${RESET}\n"
    tail -20 "$LOG_FILE" | sed 's/^/  /'
    printf "  ${DIM}  Full log: %s${RESET}\n" "$LOG_FILE"
    exit 1
  fi
  printf "  ${DIM}  Dependencies installed${RESET}\n"

  # ── Step 6: occ wrapper ──
  step "Installing occ command"
  mkdir -p "$BIN_DIR"
  cat > "$BIN_DIR/occ" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
if [ \$# -eq 0 ]; then
  exec bun run --cwd "$INSTALL_DIR/packages/openchat" --conditions=browser src/index.ts "\$PWD"
else
  exec bun run --cwd "$INSTALL_DIR/packages/openchat" --conditions=browser src/index.ts "\$@"
fi
WRAPPER
  chmod +x "$BIN_DIR/occ"

  # Add to PATH if not already there
  local shell_rc
  if [ -f "$HOME/.zshrc" ]; then shell_rc="$HOME/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then shell_rc="$HOME/.bashrc"
  else shell_rc="$HOME/.bashrc"; fi

  if ! grep -q '\.local/bin' "$shell_rc" 2>/dev/null; then
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$shell_rc"
    printf "  ${DIM}  Added ~/.local/bin to PATH in %s${RESET}\n" "$(basename "$shell_rc")"
  fi
  export PATH="$BIN_DIR:$PATH"

  printf "  ${GREEN}✓${RESET}  occ → ${BIN_DIR}/occ\n"

  # ── Step 7: Verify ──
  step "Verifying installation"
  local ver
  ver=$(grep '"version"' "$INSTALL_DIR/packages/openchat/package.json" | head -1 | sed 's/.*"version": *"\([^"]*\)".*/\1/')
  if occ --version > /dev/null 2>&1; then
    printf "  ${GREEN}✓${RESET}  OpenChat v${ver:-dev} ready\n"
  else
    printf "  ${RED}✗${RESET}  Verification failed\n"
    exit 1
  fi

  # ── Done ──
  printf "\n"
  printf "  ${GREEN}${BOLD}╔══════════════════════════════════════════╗${RESET}\n"
  printf "  ${GREEN}${BOLD}║       ✔ INSTALLATION COMPLETE           ║${RESET}\n"
  printf "  ${GREEN}${BOLD}╚══════════════════════════════════════════╝${RESET}\n\n"
  printf "  ${WHITE}OpenChat v${CYAN}%s${RESET}\n" "${ver:-dev}"
  printf "  ${WHITE}Location: ${CYAN}%s${RESET}\n" "$INSTALL_DIR"
  printf "  ${WHITE}Command:  ${GREEN}occ${RESET}\n\n"
  printf "  ${YELLOW}➜${RESET}  ${BOLD}Restart Termux${RESET} or run:  ${CYAN}source %s${RESET}\n" "$shell_rc"
  printf "  ${DIM}  Then type ${BOLD}occ${RESET}${DIM} to start chatting.${RESET}\n"
  printf "\n"
}

main "$@"
