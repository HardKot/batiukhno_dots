#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpapers"

# Проверяем существование каталога
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Directory $WALLPAPER_DIR not found!" >&2
    exit 1
fi

# Ищем изображения (поддерживаемые форматы)
mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null)

# Проверяем наличие изображений
if [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo "Error: No images found in $WALLPAPER_DIR!" >&2
    exit 1
fi

# Выбираем случайное изображение
RANDOM_IMAGE="${IMAGES[RANDOM % ${#IMAGES[@]}]}"

echo "$RANDOM_IMAGE"

