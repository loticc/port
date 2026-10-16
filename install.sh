#!/bin/bash
# ==============================================================================
# port - 安装脚本
# 作者: loticc
# 仓库: https://github.com/loticc/port
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR]${NC} 需要 root 权限，请使用 sudo bash install.sh"
    exit 1
fi

INSTALL_DIR="/usr/local/bin"
TARGET="${INSTALL_DIR}/port"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${SCRIPT_DIR}/port"

if [ ! -f "$SOURCE" ]; then
    echo -e "${RED}[ERROR]${NC} 未找到 port 脚本，请确保 install.sh 与 port 在同一目录"
    exit 1
fi

cp "$SOURCE" "$TARGET"
chmod +x "$TARGET"

if command -v port &>/dev/null; then
    echo -e "${GREEN}[OK]${NC}    安装成功！port 已安装到 ${TARGET}"
    echo -e "${GREEN}[OK]${NC}    现在可以在任意目录直接输入 port 运行"
else
    echo -e "${RED}[ERROR]${NC} 安装完成但 port 不在 PATH 中，请检查 ${INSTALL_DIR} 是否在 PATH 内"
    exit 1
fi
