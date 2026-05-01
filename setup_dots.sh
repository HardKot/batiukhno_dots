#!/bin/bash

# Скрипт для сборки конфигурации из различных веток
# Использование: ./setup_dots.sh [путь_к_папке_назначения]

DEST="${1:-$HOME/.dotfiles_compiled}"
REPO_DIR=$(pwd)

echo "--- Инициализация сборки конфигурации в $DEST ---"

mkdir -p "$DEST"

# Функция для копирования файлов из ветки
copy_branch_files() {
    local branch=$1
    local target_subdir=$2
    
    echo "Берем конфигурацию для $target_subdir из ветки $branch..."
    
    # Создаем временную директорию
    local tmp_dir=$(mktemp -d)
    
    # Клонируем ветку во временную папку (используя локальный репозиторий)
    git worktree add "$tmp_dir" "$branch" > /dev/null 2>&1
    
    # Создаем целевую подпапку
    mkdir -p "$DEST/$target_subdir"
    
    # Копируем содержимое, исключая служебные файлы git и скрипты установки
    # В разных ветках структура разная, поэтому копируем всё, кроме основы
    rsync -av --exclude='.git' --exclude='application.sh' --exclude='configurate.sh' \
          --exclude='install.sh' --exclude='Wallpapers.7z' --exclude='setup_dots.sh' \
          "$tmp_dir/" "$DEST/$target_subdir/"
          
    # Удаляем worktree
    git worktree remove "$tmp_dir" > /dev/null 2>&1
}

# 1. Neovim (из ветки nvim)
copy_branch_files "origin/nvim" "nvim"

# 2. Hyprland (из ветки hyperland)
copy_branch_files "origin/hyperland" "hypr"

# 3. Kitty (из ветки kitty)
copy_branch_files "origin/kitty" "kitty"

# 4. Waybar (из ветки waybar)
copy_branch_files "origin/waybar" "waybar"

# 5. ZSH (из ветки zsh)
copy_branch_files "zsh" "zsh"

# 6. Обои, базовые скрипты и список пакетов из master
echo "Копируем базовые скрипты и ресурсы из master..."
cp "$REPO_DIR/application.sh" "$DEST/"
cp "$REPO_DIR/configurate.sh" "$DEST/"
cp "$REPO_DIR/install.sh" "$DEST/"
cp "$REPO_DIR/packages.json" "$DEST/"
cp "$REPO_DIR/Wallpapers.7z" "$DEST/"

echo "--- Сборка завершена! ---"
echo "Теперь вы можете перейти в $DEST и запустить ./install.sh"
