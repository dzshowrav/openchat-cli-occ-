#!/data/data/com.termux/files/usr/bin/bash

set -e

REPO_URL="https://github.com/dzshowrav/openchat-cli-occ-.git"
INSTALL_DIR="${OPENCHAT_INSTALL_DIR:-$HOME/opc}"
BUN_DIR="$HOME/.bun"
BIN_DIR="$HOME/.local/bin"

REPO="dzshowrav/openchat-cli-occ-"
OCC_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/opencode"
OCC_CHECKSUM_FILE="$OCC_CACHE_DIR/install-checksum"

RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
YELLOW=$'\e[1;33m'
BLUE=$'\e[1;34m'
MAGENTA=$'\e[1;35m'
CYAN=$'\e[1;36m'
WHITE=$'\e[1;37m'
DIM=$'\e[2m'
BOLD=$'\e[1m'
RESET=$'\e[0m'
CLR=$'\e[2K\r'

spinner() {
  local pid=$1 msg=$2
  local chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "  ${CYAN}%s${RESET}  %s" "${chars:i++%${#chars}:1}" "$msg"
    sleep 0.08
  done
  wait "$pid"
  local rc=$?
  if [ $rc -eq 0 ]; then
    printf "${CLR}  ${GREEN}✓${RESET}  %s\n" "$msg"
  else
    printf "${CLR}  ${RED}✗${RESET}  %s\n" "$msg"
    return $rc
  fi
}

step() {
  printf "\n${BOLD}${BLUE}▸ %s${RESET}\n" "$1"
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
  ║     TERMUX INSTALLER v1.0            ║
  ║                                      ║
  ╚══════════════════════════════════════╝
EOF
  printf "${RESET}\n"
  printf "  ${DIM}Termux AI Coding Agent — One-Command Setup${RESET}\n\n"
}

check_deps() {
  local missing=()
  for cmd in git bun; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done
  echo "${missing[@]}"
}

print_progress() {
  local current=$1 total=$2 label=$3
  local pct=$((current * 100 / total))
  local filled=$((pct / 2))
  local empty=$((50 - filled))
  printf "  ${DIM}[${RESET}"
  printf "${CYAN}%*s${RESET}" "$filled" '' | tr ' ' '█'
  printf "%*s" "$empty" '' | tr ' ' '░'
  printf "${DIM}]${RESET}  ${BOLD}%3d%%${RESET}  ${DIM}%s${RESET}\n" "$pct" "$label"
}

install_bun() {
  step "Installing Bun runtime"
  (
    bash -c "$(curl -fsSL https://bun.sh/install 2>/dev/null)" > /dev/null 2>&1
  ) &
  spinner $! "Downloading Bun..."
  if [ -f "$BUN_DIR/bin/bun" ]; then
    export PATH="$BUN_DIR/bin:$PATH"
  fi
}

install_git() {
  step "Installing Git"
  (
    pkg install -y git > /dev/null 2>&1
  ) &
  spinner $! "Installing Git via pkg..."
}

clone_repo() {
  step "Cloning OpenChat"
  if [ -d "$INSTALL_DIR/.git" ]; then
    (
      cd "$INSTALL_DIR" && git pull --ff-only > /dev/null 2>&1
    ) &
    spinner $! "Updating existing installation..."
  else
    (
      git clone --depth=1 "$REPO_URL" "$INSTALL_DIR" > /dev/null 2>&1
    ) &
    spinner $! "Downloading OpenChat..."
  fi
}

install_deps() {
  step "Installing dependencies"
  (
    cd "$INSTALL_DIR"
    export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
    bun install > /dev/null 2>&1
  ) &
  spinner $! "Resolving and installing packages..."
}

setup_bin() {
  step "Setting up command"
  mkdir -p "$BIN_DIR"
  cat > "$BIN_DIR/occ" << WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
exec bun run --cwd "$INSTALL_DIR" --conditions=browser packages/openchat/src/index.ts "\$@"
WRAPPER
  chmod +x "$BIN_DIR/occ"
  printf "  ${GREEN}✓${RESET}  occ → ${BIN_DIR}/occ\n"
}

verify() {
  step "Verifying installation"
  local ver
  ver=$(cd "$INSTALL_DIR" && grep '"version"' packages/openchat/package.json | head -1 | sed 's/.*"version": *"\([^"]*\)".*/\1/')
  (
    cd "$INSTALL_DIR"
    export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
    bun run --cwd packages/openchat --conditions=browser src/index.ts --version > /dev/null 2>&1
  ) &
  spinner $! "Testing OpenChat v${ver:-dev}..."
  
  printf "\n"
  if [ -f "$BIN_DIR/occ" ]; then
    printf "\n  ${GREEN}${BOLD}╔══════════════════════════════════════════╗${RESET}\n"
    printf "  ${GREEN}${BOLD}║          ✔ INSTALLATION COMPLETE        ║${RESET}\n"
    printf "  ${GREEN}${BOLD}╚══════════════════════════════════════════╝${RESET}\n\n"
    printf "  ${WHITE}OpenChat v${CYAN}%s${RESET}\n" "${ver:-dev}"
    printf "  ${WHITE}Location: ${CYAN}%s${RESET}\n" "$INSTALL_DIR"
    printf "  ${WHITE}Command:  ${GREEN}occ${RESET}\n\n"
    printf "  ${DIM}Just type ${BOLD}occ${RESET}${DIM} to start chatting.${RESET}\n"
    printf "  ${DIM}First run downloads language models (~50MB).${RESET}\n"
  else
    printf "\n  ${RED}${BOLD}╔══════════════════════════════════════════╗${RESET}\n"
    printf "  ${RED}${BOLD}║          ✘ INSTALLATION FAILED           ║${RESET}\n"
    printf "  ${RED}${BOLD}╚══════════════════════════════════════════╝${RESET}\n\n"
    exit 1
  fi
}

cleanup() {
  printf "\n"
  printf "  ${DIM}────────────────────────────────────────────${RESET}\n"
  printf "  ${DIM}  Need help?  ${CYAN}https://github.com/dzshowrav/openchat-cli-occ-${RESET}\n"
  printf "  ${DIM}────────────────────────────────────────────${RESET}\n"
  printf "\n"
}

STEPS=("Dependencies" "Download" "Packages" "Setup" "Verify")
STEP_N=0

next_step() {
  local label="$1"
  printf "\n${BOLD}${BLUE}▸ Step %d/%d: %s${RESET}\n" $((STEP_N + 1)) "${#STEPS[@]}" "$label"
}

complete_step() {
  STEP_N=$((STEP_N + 1))
  print_progress "$STEP_N" "${#STEPS[@]}" "$1"
}

main() {
  banner

  if ! command -v git >/dev/null 2>&1 || ! command -v bun >/dev/null 2>&1; then
    printf "  ${YELLOW}⚠  Installing missing dependencies${RESET}\n\n"
  fi

  next_step "System dependencies"
  if ! command -v git >/dev/null 2>&1; then
    install_git
  else
    printf "  ${GREEN}✓${RESET}  Git found\n"
  fi
  if ! command -v bun >/dev/null 2>&1; then
    install_bun
  else
    printf "  ${GREEN}✓${RESET}  Bun $(bun --version) found\n"
  fi
  complete_step "Dependencies ready"

  next_step "Download OpenChat"
  clone_repo
  complete_step "Repository cloned"

  next_step "Install packages"
  install_deps
  complete_step "All packages installed"

  next_step "Setup occ command"
  setup_bin
  complete_step "Command configured"

  next_step "Verify"
  verify
  complete_step "Ready to use"

  cleanup
}

main "$@"
