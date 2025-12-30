#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)


if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "Error: Directory $WALLPAPER_DIR not found!" >&2
    exit 1
fi

mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null)

if [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo "Error: No images found in $WALLPAPER_DIR!" >&2
    exit 1
fi

WALLPAPER="${IMAGES[RANDOM % ${#IMAGES[@]}]}"

hyprctl hyprpaper wallpaper "HDMI-A-1,$WALLPAPER,cover"
cp "$WALLPAPER" $HOME/Wallpapers/lockScreen.png
