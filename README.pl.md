[![OpenChat Terminal UI](packages/web/src/assets/lander/screenshot.png)](https://openchat.ai)

<p align="center">
  <a href="https://openchat.ai/discord"><img alt="Discord" src="https://img.shields.io/discord/1391832426048651334?style=flat-square&label=discord" /></a>
  <a href="https://www.npmjs.com/package/openchat-ai"><img alt="npm" src="https://img.shields.io/npm/v/openchat-ai?style=flat-square" /></a>
  <a href="https://github.com/dzshowrav/openchat/actions/workflows/publish.yml"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/dzshowrav/openchat/publish.yml?style=flat-square&branch=dev" /></a>
</p>

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.zh.md">简体中文</a> |
  <a href="README.zht.md">繁體中文</a> |
  <a href="README.ko.md">한국어</a> |
  <a href="README.de.md">Deutsch</a> |
  <a href="README.es.md">Español</a> |
  <a href="README.fr.md">Français</a> |
  <a href="README.it.md">Italiano</a> |
  <a href="README.da.md">Dansk</a> |
  <a href="README.ja.md">日本語</a> |
  <a href="README.pl.md">Polski</a> |
  <a href="README.ru.md">Русский</a> |
  <a href="README.bs.md">Bosanski</a> |
  <a href="README.ar.md">العربية</a> |
  <a href="README.no.md">Norsk</a> |
  <a href="README.br.md">Português (Brasil)</a> |
  <a href="README.th.md">ไทย</a> |
  <a href="README.tr.md">Türkçe</a> |
  <a href="README.uk.md">Українська</a> |
  <a href="README.bn.md">বাংলা</a> |
  <a href="README.gr.md">Ελληνικά</a> |
  <a href="README.vi.md">Tiếng Việt</a>
</p>

---

### Instalacja

```bash
# YOLO
curl -fsSL https://openchat.ai/install | bash

# Menedżery pakietów
npm i -g openchat-ai@latest        # albo bun/pnpm/yarn
scoop install openchat             # Windows
choco install openchat             # Windows
brew install dzshowrav/tap/openchat # macOS i Linux (polecane, zawsze aktualne)
brew install openchat              # macOS i Linux (oficjalna formuła brew, rzadziej aktualizowana)
sudo pacman -S openchat            # Arch Linux (Stable)
paru -S openchat-bin               # Arch Linux (Latest from AUR)
mise use -g openchat               # dowolny system
nix run nixpkgs#openchat           # lub github:dzshowrav/openchat dla najnowszej gałęzi dev
```

> [!TIP]
> Przed instalacją usuń wersje starsze niż 0.1.x.

### Aplikacja desktopowa (BETA)

OpenChat jest także dostępny jako aplikacja desktopowa. Pobierz ją bezpośrednio ze strony [releases](https://github.com/dzshowrav/openchat/releases) lub z [openchat.ai/download](https://openchat.ai/download).

| Platforma             | Pobieranie                         |
| --------------------- | ---------------------------------- |
| macOS (Apple Silicon) | `openchat-desktop-mac-arm64.dmg`   |
| macOS (Intel)         | `openchat-desktop-mac-x64.dmg`     |
| Windows               | `openchat-desktop-windows-x64.exe` |
| Linux                 | `.deb`, `.rpm` lub AppImage        |

```bash
# macOS (Homebrew)
brew install --cask openchat-desktop
# Windows (Scoop)
scoop bucket add extras; scoop install extras/openchat-desktop
```

#### Katalog instalacji

Skrypt instalacyjny stosuje następujący priorytet wyboru ścieżki instalacji:

1. `$OPENCHAT_INSTALL_DIR` - Własny katalog instalacji
2. `$XDG_BIN_DIR` - Ścieżka zgodna ze specyfikacją XDG Base Directory
3. `$HOME/bin` - Standardowy katalog binarny użytkownika (jeśli istnieje lub można go utworzyć)
4. `$HOME/.openchat/bin` - Domyślny fallback

```bash
# Przykłady
OPENCHAT_INSTALL_DIR=/usr/local/bin curl -fsSL https://openchat.ai/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://openchat.ai/install | bash
```

### Agents

OpenChat zawiera dwóch wbudowanych agentów, między którymi możesz przełączać się klawiszem `Tab`.

- **build** - Domyślny agent z pełnym dostępem do pracy developerskiej
- **plan** - Agent tylko do odczytu do analizy i eksploracji kodu
  - Domyślnie odmawia edycji plików
  - Pyta o zgodę przed uruchomieniem komend bash
  - Idealny do poznawania nieznanych baz kodu lub planowania zmian

Dodatkowo jest subagent **general** do złożonych wyszukiwań i wieloetapowych zadań.
Jest używany wewnętrznie i można go wywołać w wiadomościach przez `@general`.

Dowiedz się więcej o [agents](https://openchat.ai/docs/agents).

### Dokumentacja

Więcej informacji o konfiguracji OpenChat znajdziesz w [**dokumentacji**](https://openchat.ai/docs).

### Współtworzenie

Jeśli chcesz współtworzyć OpenChat, przeczytaj [contributing docs](./CONTRIBUTING.md) przed wysłaniem pull requesta.

### Budowanie na OpenChat

Jeśli pracujesz nad projektem związanym z OpenChat i używasz "openchat" jako części nazwy (na przykład "openchat-dashboard" lub "openchat-mobile"), dodaj proszę notatkę do swojego README, aby wyjaśnić, że projekt nie jest tworzony przez zespół OpenChat i nie jest z nami w żaden sposób powiązany.

---

**Dołącz do naszej społeczności** [Discord](https://discord.gg/openchat) | [X.com](https://x.com/openchat)
