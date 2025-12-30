#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$($HOME/Scripts/random-wallpaper.sh)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
cp "$WALLPAPER" $HOME/Wallpapers/lockScreen.png
