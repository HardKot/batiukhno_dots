#!/bin/bash

DEFAULT_DAYS=2
DEFAULT_SNAPSHOTS=2

# Парсинг параметров
DAYS=${1:-$DEFAULT_DAYS}
MAX_SNAPSHOTS=${2:-$DEFAULT_SNAPSHOTS}
COMMENT_FILTER=${3:-"Pre-update snapshot"}
SNAPSHOT_SOURCE=${4:-"unknown"}

# Проверка корректности параметров
if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: количество дней должно быть положительным числом"
    exit 1
fi

if ! [[ "$MAX_SNAPSHOTS" =~ ^[0-9]+$ ]] || [ "$MAX_SNAPSHOTS" -lt 1 ]; then
    echo "Ошибка: максимальное количество снапшотов должно быть положительным числом"
    exit 1
fi

# Пропуск создания снапшота, если задана переменная
if [ "${SKIP_AUTOSNAP}" = "1" ]; then
    echo "Автоматическое создание снапшота пропущено (SKIP_AUTOSNAP=1)"
    exit 0
fi

my-backup "$COMMENT_FILTER: $SNAPSHOT_SOURCE"

my-backup-delete "$DAYS" "$MAX_SNAPSHOTS" "$COMMENT_FILTER"


