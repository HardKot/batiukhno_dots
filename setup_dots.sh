#!/bin/bash

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
