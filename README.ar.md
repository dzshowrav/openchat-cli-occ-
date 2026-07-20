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

### التثبيت

```bash
# YOLO
curl -fsSL https://openchat.ai/install | bash

# مديري الحزم
npm i -g openchat-ai@latest        # او bun/pnpm/yarn
scoop install openchat             # Windows
choco install openchat             # Windows
brew install dzshowrav/tap/openchat # macOS و Linux (موصى به، دائما محدث)
brew install openchat              # macOS و Linux (صيغة brew الرسمية، تحديث اقل)
sudo pacman -S openchat            # Arch Linux (Stable)
paru -S openchat-bin               # Arch Linux (Latest from AUR)
mise use -g openchat               # اي نظام
nix run nixpkgs#openchat           # او github:dzshowrav/openchat لاحدث فرع dev
```

> [!TIP]
> احذف الاصدارات الاقدم من 0.1.x قبل التثبيت.

### تطبيق سطح المكتب (BETA)

يتوفر OpenChat ايضا كتطبيق سطح مكتب. قم بالتنزيل مباشرة من [صفحة الاصدارات](https://github.com/dzshowrav/openchat/releases) او من [openchat.ai/download](https://openchat.ai/download).

| المنصة                | التنزيل                            |
| --------------------- | ---------------------------------- |
| macOS (Apple Silicon) | `openchat-desktop-mac-arm64.dmg`   |
| macOS (Intel)         | `openchat-desktop-mac-x64.dmg`     |
| Windows               | `openchat-desktop-windows-x64.exe` |
| Linux                 | `.deb` او `.rpm` او AppImage       |

```bash
# macOS (Homebrew)
brew install --cask openchat-desktop
# Windows (Scoop)
scoop bucket add extras; scoop install extras/openchat-desktop
```

#### مجلد التثبيت

يحترم سكربت التثبيت ترتيب الاولوية التالي لمسار التثبيت:

1. `$OPENCHAT_INSTALL_DIR` - مجلد تثبيت مخصص
2. `$XDG_BIN_DIR` - مسار متوافق مع مواصفات XDG Base Directory
3. `$HOME/bin` - مجلد الثنائيات القياسي للمستخدم (ان وجد او امكن انشاؤه)
4. `$HOME/.openchat/bin` - المسار الافتراضي الاحتياطي

```bash
# امثلة
OPENCHAT_INSTALL_DIR=/usr/local/bin curl -fsSL https://openchat.ai/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://openchat.ai/install | bash
```

### Agents

يتضمن OpenChat وكيليْن (Agents) مدمجين يمكنك التبديل بينهما باستخدام زر `Tab`.

- **build** - الافتراضي، وكيل بصلاحيات كاملة لاعمال التطوير
- **plan** - وكيل للقراءة فقط للتحليل واستكشاف الكود
  - يرفض تعديل الملفات افتراضيا
  - يطلب الاذن قبل تشغيل اوامر bash
  - مثالي لاستكشاف قواعد كود غير مألوفة او لتخطيط التغييرات

بالاضافة الى ذلك يوجد وكيل فرعي **general** للبحث المعقد والمهام متعددة الخطوات.
يستخدم داخليا ويمكن استدعاؤه بكتابة `@general` في الرسائل.

تعرف على المزيد حول [agents](https://openchat.ai/docs/agents).

### التوثيق

لمزيد من المعلومات حول كيفية ضبط OpenChat، [**راجع التوثيق**](https://openchat.ai/docs).

### المساهمة

اذا كنت مهتما بالمساهمة في OpenChat، يرجى قراءة [contributing docs](./CONTRIBUTING.md) قبل ارسال pull request.

### البناء فوق OpenChat

اذا كنت تعمل على مشروع مرتبط بـ OpenChat ويستخدم "openchat" كجزء من اسمه (مثل "openchat-dashboard" او "openchat-mobile")، يرجى اضافة ملاحظة في README توضح انه ليس مبنيا بواسطة فريق OpenChat ولا يرتبط بنا بأي شكل.

---

**انضم الى مجتمعنا** [Discord](https://discord.gg/openchat) | [X.com](https://x.com/openchat)
