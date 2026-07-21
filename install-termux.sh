#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "========================================="
echo " OpenChat CLI (OCC) Installer for Termux "
echo "========================================="

# 1. Update packages
echo "[1/9] Updating packages..."
pkg update -y
pkg upgrade -y

# 2. Install dependencies
echo "[2/9] Installing dependencies..."
pkg install -y git curl ca-certificates binutils termux-exec nodejs

# 3. Add Termux Bun repository
echo "[3/9] Adding Bun repository..."
curl -sL https://github.com/termuxvoid/repo/raw/main/install.sh | bash

# 4. Install Bun
echo "[4/9] Installing Bun..."
pkg update -y
pkg upgrade -y
pkg install -y bun

# 5. Clone repository
echo "[5/9] Cloning OpenChat CLI..."
rm -rf ~/opc
git clone https://github.com/dzshowrav/openchat-cli-occ- ~/opc

# 6. Install JavaScript dependencies
echo "[6/9] Installing Bun packages..."
cd ~/opc
export LD_PRELOAD=/data/data/com.termux/files/usr/lib/libtermux-exec-ld-preload.so
bun install

# 7. Create OCC wrapper
echo "[7/9] Creating occ command..."
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

# 8. Add PATH
echo "[8/9] Updating PATH..."
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc || \
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

export PATH="$HOME/.local/bin:$PATH"

# 9. Verify installation
echo "[9/9] Verifying installation..."
occ --version

echo
echo "========================================="
echo " Installation completed successfully!"
echo " Run: occ"
echo "========================================="
