#!/bin/bash

# Цвета для вывода
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Настройка ZSH, Oh My Zsh и Powerlevel10k ===${NC}"

# 1. Установка Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Установка Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh уже установлен."
fi

# 2. Установка Powerlevel10k
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Установка темы Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k уже установлен."
fi

# 3. Установка плагинов (autosuggestions и syntax-highlighting)
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# Autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo "Установка zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# Syntax Highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo "Установка zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

# 4. Установка дополнительных системных плагинов через pacman
echo "Установка системных зависимостей для плагинов (nvm, docker)..."
sudo pacman -S --noconfirm nvm docker

# 5. Копирование конфига
if [ -f "zsh/zshrc" ]; then
    echo "Копирование .zshrc..."
    cp zsh/zshrc "$HOME/.zshrc"
elif [ -f "../zsh/zshrc" ]; then
    echo "Копирование .zshrc из родительской директории..."
    cp ../zsh/zshrc "$HOME/.zshrc"
fi

# 5. Смена дефолтной оболочки
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Смена оболочки на ZSH..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

echo -e "${GREEN}Настройка ZSH завершена!${NC}"
