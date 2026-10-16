#!/usr/bin/env bash
set -Eeuo pipefail

# ==================== 基本配置 ====================
REPO_RAW="https://raw.githubusercontent.com/loticc/port/main"
INSTALL_DIR="/usr/local/bin"
TARGET="${INSTALL_DIR}/port"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==================== 权限检查 ====================
if [[ "$(id -u)" -ne 0 ]]; then
    echo -e "${RED}[错误]${NC} 安装脚本需要 root 权限。"
    echo "请使用以下命令重新运行："
    echo "  sudo bash $0"
    echo "或者先切换到 root 用户后再执行。"
    exit 1
fi

# ==================== 下载工具检查 ====================
DOWNLOADER=""
if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
else
    echo -e "${RED}[错误]${NC} 未找到 curl 或 wget。"
    echo "请先安装其中一个，例如："
    echo "  apt update && apt install -y curl"
    exit 1
fi

# ==================== 下载 port 脚本 ====================
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

echo -e "${GREEN}[信息]${NC} 正在下载 port 脚本..."

if [[ "$DOWNLOADER" == "curl" ]]; then
    if ! curl -fsSL "${REPO_RAW}/port" -o "$TMP_FILE"; then
        echo -e "${RED}[错误]${NC} 下载失败，请检查网络连接。"
        exit 1
    fi
else
    if ! wget -qO "$TMP_FILE" "${REPO_RAW}/port"; then
        echo -e "${RED}[错误]${NC} 下载失败，请检查网络连接。"
        exit 1
    fi
fi

if [[ ! -s "$TMP_FILE" ]]; then
    echo -e "${RED}[错误]${NC} 下载的脚本为空，安装已终止。"
    exit 1
fi

# ==================== 安装脚本 ====================
echo -e "${GREEN}[信息]${NC} 正在安装..."

install -d "$INSTALL_DIR"
install -m 0755 "$TMP_FILE" "$TARGET"

if [[ ! -x "$TARGET" ]]; then
    echo -e "${RED}[错误]${NC} 安装失败，请检查系统权限。"
    exit 1
fi

# ==================== 安装成功提示 ====================
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}          安装成功！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "SSH 端口修改工具已成功安装。"
echo "安装位置：${TARGET}"
echo ""
echo -e "${YELLOW}以后需要再次运行本工具，请输入：${NC}"
echo -e "  ${GREEN}port${NC}"
echo ""
echo "如果提示找不到命令，请使用完整路径："
echo -e "  ${GREEN}${TARGET}${NC}"
echo ""
echo "注意：安装完成后尚未修改 SSH 端口。"
echo "请运行上面的命令开始使用。"
echo ""
echo -e "${GREEN}========================================${NC}"
