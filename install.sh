#!/bin/bash
# ==============================================================================
# port - 安装脚本
# 作者: loticc
# 仓库: https://github.com/loticc/port
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'#!/bin/bash
# ==============================================================================
# port - 安装脚本
# 作者: loticc
# 仓库: https://github.com/loticc/port
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR]${NC} 需要 root 权限，请使用 sudo bash install.sh"
    exit 1
fi

INSTALL_DIR="/usr/local/bin"
TARGET="${INSTALL_DIR}/port"

# 修复：BASH_SOURCE[0] 在管道执行时无效，用 ${BASH_SOURCE[0]:-} 提供默认值
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
SOURCE="${SCRIPT_DIR}/port"

echo -e "${GREEN}[INFO]${NC} 当前目录: ${SCRIPT_DIR}"
echo -e "${GREEN}[INFO]${NC} 查找 port 文件: ${SOURCE}"

# 如果当前目录没有 port 文件，尝试从 GitHub 下载
if [ ! -f "$SOURCE" ]; then
    echo -e "${YELLOW}[WARN]${NC} 未找到 port 文件，尝试从 GitHub 下载..."
    
    if command -v curl &>/dev/null; then
        curl -fsSL "https://raw.githubusercontent.com/loticc/port/main/port" -o port
    elif command -v wget &>/dev/null; then
        wget -q "https://raw.githubusercontent.com/loticc/port/main/port"
    else
        error "需要 curl 或 wget 来下载 port 文件"
        exit 1
    fi
    
    # 检查下载是否成功
    if [ ! -f "port" ]; then
        echo -e "${RED}[ERROR]${NC} 下载 port 文件失败，请检查网络连接"
        exit 1
    fi
    echo -e "${GREEN}[OK]${NC}  port 文件下载成功"
fi

cp "$SOURCE" "$TARGET"
chmod +x "$TARGET"

# 验证安装
if command -v port &>/dev/null; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  安装成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "  port 已安装到: ${TARGET}"
    echo -e ""
    echo -e "  ${YELLOW}使用方法：在任意目录输入以下命令即可调用${NC}"
    echo -e "  ${YELLOW}  port${NC}"
    echo -e ""
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}[ERROR]${NC} 安装完成但 port 不在 PATH 中，请检查 ${INSTALL_DIR} 是否在 PATH 内"
    echo -e "${RED}[ERROR]${NC} PATH 内容: ${PATH}"
    exit 1
fi
NC='\033[0m'

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR]${NC} 需要 root 权限，请使用 sudo bash install.sh"
    exit 1
fi

INSTALL_DIR="/usr/local/bin"
TARGET="${INSTALL_DIR}/port"

# 修复：BASH_SOURCE[0] 在管道执行时无效，用 ${BASH_SOURCE[0]:-} 提供默认值
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-}")" && pwd)"
SOURCE="${SCRIPT_DIR}/port"

echo -e "${GREEN}[INFO]${NC} 当前目录: ${SCRIPT_DIR}"
echo -e "${GREEN}[INFO]${NC} 查找 port 文件: ${SOURCE}"

if [ ! -f "$SOURCE" ]; then
    echo -e "${RED}[ERROR]${NC} 未找到 port 脚本，请确保 install.sh 与 port 在同一目录"
    echo -e "${RED}[ERROR]${NC} 当前目录内容: $(ls -la "$SCRIPT_DIR" 2>/dev/null || echo '无法列出')"
    exit 1
fi

cp "$SOURCE" "$TARGET"
chmod +x "$TARGET"

# 验证安装
if command -v port &>/dev/null; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  安装成功！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "  port 已安装到: ${TARGET}"
    echo -e ""
    echo -e "  ${YELLOW}使用方法：在任意目录输入以下命令即可调用${NC}"
    echo -e "  ${YELLOW}  port${NC}"
    echo -e ""
    echo -e "${GREEN}========================================${NC}"
else
    echo -e "${RED}[ERROR]${NC} 安装完成但 port 不在 PATH 中，请检查 ${INSTALL_DIR} 是否在 PATH 内"
    echo -e "${RED}[ERROR]${NC} PATH 内容: ${PATH}"
    exit 1
fi
