#!/bin/bash

# Создание стандартной структуры директорий пользователя
echo "Создание структуры папок в домашнем каталоге..."

mkdir -p ~/Documents
mkidr -p ~/Documents/Security

mkdir -p ~/Wallpapers
mkdir -p ~/Projects
mkdir -p ~/Music
mkdir -p ~/Scripts
mkdir -p ~/Downloads
mkdir -p ~/Games

echo "Создание корзины"

mkdir -p ~/.local/share/Trash/files
mkdir -p ~/.local/share/Trash/info

echo "Структура папок создана."
