#!/bin/bash

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Глобальная настройка системы ===${NC}"

# 1. Проверка окружения
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Ошибка: Этот скрипт предназначен для Arch Linux (pacman не найден).${NC}"
    exit 1
fi

echo -e "${BLUE}Создание структуры папок...${NC}"
chmod +x configurate.sh && ./configurate.sh

echo -e "${BLUE}Установка приложений...${NC}"
chmod +x application.sh && sudo ./application.sh

echo -e "${BLUE}Установка тем и шрифтов...${NC}"
chmod +x themes.sh && ./themes.sh

echo -e "${BLUE}Настройка конфигураций...${NC}"
chmod +x setup_dots.sh && ./setup_dots.sh

echo -e "${BLUE}Настройка SHELL...${NC}"
chmod +x zsh_config.sh && ./zsh_config.sh

echo -e "${GREEN}=== Настройка завершена! ===${NC}"

echo -e "${BLUE}Пожалуйста, перезагрузите систему или перезапустите сессию.${NC}"

