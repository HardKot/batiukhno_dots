#!/bin/bash
# 1. Создаем папку для будущих дотфайлов
mkdir -p ~/Scripts/dotfiles
cd ~/Scripts/dotfiles

# 2. Скачиваем ваши конфигурации из веток и раскладываем для Stow
git clone --branch nvim https://github.com/HardKot/batiukhno_dots.git tmp_nvim
mkdir -p nvim/.config
mv tmp_nvim nvim/.config/nvim

git clone --branch kitty https://github.com/HardKot/batiukhno_dots.git tmp_kitty
mkdir -p kitty/.config
mv tmp_kitty kitty/.config/kitty

git clone --branch hyperland https://github.com/HardKot/batiukhno_dots.git tmp_hypr
mkdir -p hyprland/.config
mv tmp_hypr hyprland/.config/hypr

git clone --branch waybar https://github.com/HardKot/batiukhno_dots.git tmp_waybar
mkdir -p waybar/.config
mv tmp_waybar waybar/.config/waybar

# 3. Удаляем папки .git из вложенных скачанных репозиториев (так как теперь всё будет в одном master-репозитории)
find . -type d -name ".git" -exec rm -rf {} +