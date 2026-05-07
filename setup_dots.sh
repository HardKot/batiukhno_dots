#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Настройка dotfiles с помощью GNU Stow...${NC}"

DOTFILES_DIR="$HOME/Scripts/dotfiles"
CONF_DIR="$HOME/.config"

# Важно: Предварительно создаем каталоги, чтобы Stow создавал симлинки на уровене файлов, а не папок
# Это особенно критично для systemd, чтобы системные папки (вроде .wants) не попадали в git 
echo "Создание структуры необходимых директорий..."
mkdir -p "$CONF_DIR/systemd/user"

cd "$DOTFILES_DIR" || { echo "Ошибка: Директория с дотфайлами ($DOTFILES_DIR) не найдена!"; exit 1; }

echo -e "${BLUE}Применение конфигураций stow...${NC}"
# Привязываем все пакеты из dotfiles через Stow в домашнюю директорию (-t ~)
stow -t ~ nvim kitty hyprland waybar fish systemd

echo -e "${BLUE}Перезагрузка пользовательских сервисов systemd...${NC}"
systemctl --user daemon-reload
# Включаем и запускаем наш таймер для обоев
systemctl --user --quiet enable change-wallpaper.timer

echo -e "${GREEN}Дотфайлы успешно настроены!${NC}"
