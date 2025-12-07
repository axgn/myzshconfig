#!/usr/bin/env bash

install_nerd_font() {
    FONT_NAME="FiraCode"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
    FONT_DIR="$HOME/.local/share/fonts"

    echo "==> Installing ${FONT_NAME} Nerd Font..."

    mkdir -p "$FONT_DIR"
    tmp_dir=$(mktemp -d)

    # 下载
    echo "Downloading Nerd Font..."
    curl -L "$FONT_URL" -o "$tmp_dir/font.zip"

    # 解压
    echo "Extracting..."
    unzip "$tmp_dir/font.zip" -d "$tmp_dir" >/dev/null

    # 拷贝字体文件
    echo "Copying fonts..."
    find "$tmp_dir" -name "*.ttf" -exec cp {} "$FONT_DIR" \;

    # 刷新字体缓存
    echo "Updating font cache..."
    fc-cache -fv >/dev/null

    echo "==> Nerd Font installed successfully."
}


set -e

echo "[*] 更新系统包..."
sudo apt update -y

echo "[*] 安装 zsh..."
sudo apt install -y zsh git curl

# 如果已经安装 oh-my-zsh 就不重复安装
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[*] 安装 oh-my-zsh..."
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[+] 已检测到 oh-my-zsh，跳过安装"
fi

ZSHRC="$HOME/.zshrc"

echo "[*] 安装插件：zsh-autosuggestions"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "[+] zsh-autosuggestions 已存在"
fi

echo "[*] 安装插件：zsh-syntax-highlighting"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "[+] zsh-syntax-highlighting 已存在"
fi

echo "[*] 安装主题：powerlevel10k"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "[+] powerlevel10k 已存在"
fi

echo "安装字体"

install_nerd_font

echo "cope configure file"
cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh

echo "[*] 设置 zsh 为默认 shell..."
chsh -s "$(which zsh)"

echo "[✔] 完成！重新打开终端即可进入 zsh 环境。"
