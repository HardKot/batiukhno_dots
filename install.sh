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

# 6. Установка конфигураций (Dotfiles) через клонирование веток
echo -e "${BLUE}Установка конфигураций...${NC}"
CONF_DIR="$HOME/.config"
mkdir -p "$CONF_DIR"
REPO_URL="https://github.com/HardKot/batiukhno_dots.git"

clone_config() {
    local branch=$1
    local dest=$2
    local target_path="$CONF_DIR/$dest"

    if [ -d "$target_path" ]; then
        echo "Обновление $dest из ветки $branch..."
        cd "$target_path" && git pull origin "$branch" && cd - > /dev/null
    else
        echo "Клонирование $dest из ветки $branch..."
        git clone -b "$branch" --depth 1 "$REPO_URL" "$target_path"
        # Удаляем лишние файлы, если они есть в ветке (скрипты, JSON и т.д.)
        find "$target_path" -maxdepth 1 -type f \( -name "*.sh" -o -name "*.json" -o -name "*.7z" \) -delete
    fi
}

clone_config "nvim" "nvim"
clone_config "kitty" "kitty"
clone_config "hyperland" "hypr"
clone_config "waybar" "waybar"

# ZSH отдельно, так как он не в .config
ZSH_PATH="$HOME/.dotfiles-zsh"
if [ ! -d "$ZSH_PATH" ]; then
    echo "Клонирование ZSH конфигурации..."
    git clone -b "zsh" --depth 1 "$REPO_URL" "$ZSH_PATH"
fi

# Oh My Zsh и тема
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Установка Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Установка темы Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "Настройка .zshrc..."
ln -sf "$ZSH_PATH/zshrc" "$HOME/.zshrc"

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Смена оболочки на ZSH..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

echo -e "${GREEN}=== Настройка завершена! ===${NC}"

echo -e "${BLUE}Пожалуйста, перезагрузите систему или перезапустите сессию.${NC}"

