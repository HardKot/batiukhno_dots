#!/bin/bash


if [ -f "Wallpapers.7z" ]; then
    echo -e "${BLUE}Распаковка обоев...${NC}"
    7z x Wallpapers.7z -o"$HOME/Wallpapers" -y
fi

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
