
#!/usr/bin/env bash
set -Eeuo pipefail

REPO_RAW="https://raw.githubusercontent.com/loticc/port/main"
INSTALL_DIR="/usr/local/bin"
TARGET="${INSTALL_DIR}/port"

# Check root privileges
if [[ "$(id -u)" -ne 0 ]]; then
    echo "[ERROR] Please run with root privileges."
    echo "Use: sudo bash install.sh"
    exit 1
fi

# Check download tools
if ! command -v curl >/dev/null 2>&1 &&
   ! command -v wget >/dev/null 2>&1; then
    echo "[ERROR] curl or wget is required."
    exit 1
fi

# Download the latest port script
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

echo "[INFO] Downloading port..."

if command -v curl >/dev/null 2>&1; then
    if ! curl -fsSL "${REPO_RAW}/port" -o "$TMP_FILE"; then
        echo "[ERROR] Failed to download port."
        exit 1
    fi
else
    if ! wget -qO "$TMP_FILE" "${REPO_RAW}/port"; then
        echo "[ERROR] Failed to download port."
        exit 1
    fi
fi

if [[ ! -s "$TMP_FILE" ]]; then
    echo "[ERROR] Downloaded file is empty."
    exit 1
fi

# Install the script
install -d "$INSTALL_DIR"
install -m 0755 "$TMP_FILE" "$TARGET"

if [[ ! -x "$TARGET" ]]; then
    echo "[ERROR] Installation failed."
    exit 1
fi

# Installation success message
echo ""
echo "========================================"
echo "  Installation successful!"
echo "========================================"
echo "  Installed to: ${TARGET}"
echo ""
echo "  To run the tool again, use:"
echo "    sudo port"
echo ""
echo "  Or use the full path:"
echo "    sudo ${TARGET}"
echo "========================================"
