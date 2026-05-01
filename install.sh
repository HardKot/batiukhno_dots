#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Глобальная настройка системы ===${NC}"

# 1. Проверка окружения
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Ошибка: Этот скрипт предназначен для Arch Linux (pacman не найден).${NC}"
    exit 1
fi

# 2. Базовая конфигурация папок
echo -e "${BLUE}Создание структуры папок...${NC}"
chmod +x configurate.sh
./configurate.sh

# 3. Установка приложений через application.sh
echo -e "${BLUE}Установка приложений...${NC}"
chmod +x application.sh
sudo ./application.sh

# 4. Распаковка обоев
if [ -f "Wallpapers.7z" ]; then
    echo -e "${BLUE}Распаковка обоев...${NC}"
    7z x Wallpapers.7z -o"$HOME/Wallpapers" -y
fi

# 5. Шрифты
echo -e "${BLUE}Установка шрифтов...${NC}"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

install_font() {
    local name=$1
    local url=$2
    echo "Загрузка $name..."
    curl -L -o "$name.tar.xz" "$url"
    mkdir -p "$name"
    tar -xJf "$name.tar.xz" -C "$name"
    find "$name" -name "*NerdFont*" -exec mv {} "$FONT_DIR/" \;
    rm -rf "$name" "$name.tar.xz"
}

if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
    install_font "JetBrainsMono" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.tar.xz"
fi

if [ ! -d "$FONT_DIR/Noto" ]; then
    install_font "Noto" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Noto.tar.xz"
fi

fc-cache -fv

# 6. Символические ссылки для конфигураций (Dotfiles)
echo -e "${BLUE}Создание символических ссылок для конфигураций...${NC}"
CONF_DIR="$HOME/.config"
mkdir -p "$CONF_DIR"

DOTS_SOURCE=$(pwd)

# ZSH и Oh My Zsh
if [ -d "zsh" ] && [ -f "zsh/zshrc" ]; then
    echo -e "${BLUE}Настройка ZSH и Oh My Zsh...${NC}"
    
    # Установка Oh My Zsh если не установлен
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Установка Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Установка плагинов/тем (Powerlevel10k судя по конфигу)
    P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$P10K_DIR" ]; then
        echo "Установка темы Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    fi

    echo "Линковка .zshrc..."
    ln -sf "$DOTS_SOURCE/zsh/zshrc" "$HOME/.zshrc"
    
    # Смена дефолтного шелла
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Смена оболочки на ZSH..."
        sudo chsh -s "$(which zsh)" "$USER"
    fi
fi

link_config() {
    local src=$1
    local dest=$2
    if [ -d "$src" ]; then
        echo "Линковка $dest..."
        rm -rf "$CONF_DIR/$dest"
        ln -snf "$DOTS_SOURCE/$src" "$CONF_DIR/$dest"
    else
        echo -e "${RED}Предупреждение: Директория $src не найдена, пропуск.${NC}"
    fi
}

link_config "nvim" "nvim"
link_config "kitty" "kitty"
link_config "hypr" "hypr"
link_config "waybar" "waybar"

echo -e "${GREEN}=== Настройка завершена! ===${NC}"
echo -e "${BLUE}Пожалуйста, перезагрузите систему или перезапустите сессию.${NC}"

