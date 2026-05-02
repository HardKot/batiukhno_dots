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

SNAPSHOT_COMMENT="$COMMENT_FILTER: $SNAPSHOT_SOURCE at $(date '+%Y-%m-%d %H:%M:%S')"
echo "Создание снапшота Timeshift: $SNAPSHOT_COMMENT"

# Создаём снапшот с тегом O и комментарием
sudo timeshift --create --comments "$SNAPSHOT_COMMENT" --tags O

if [ $? -ne 0 ]; then
    echo "Ошибка при создании снапшота"
    exit 1
fi
echo "Снапшот успешно создан"

# Очистка: удаляем снапшоты старше X дней с тегом O И комментарием, содержащим $COMMENT_FILTER
echo "Удаляем снапшоты с тегом O старше $DAYS дней и комментарием '$COMMENT_FILTER'..."

SNAPSHOTS_TO_DELETE_BY_AGE=$(timeshift --list --tags O --sort oldest 2>/dev/null | \
    grep "$COMMENT_FILTER" | \
    awk -v days="$DAYS" '{
        # Парсим дату из имени снапшота (формат YYYY-MM-DD_HH-MM-SS)
        split($1, date_parts, /[-_]/);
        snapshot_date = date_parts[1] "-" date_parts[2] "-" date_parts[3];
        cmd = "date -d \"" snapshot_date "\" +%s";
        cmd | getline epoch;
        close(cmd);

        # Текущая дата в секундах
        cmd2 = "date +%s";
        cmd2 | getline now;
        close(cmd2);

        # 86400 секунд в дне
        if (now - epoch > days * 86400) {
            print $1
        }
    }')

if [ -n "$SNAPSHOTS_TO_DELETE_BY_AGE" ]; then
    echo "Следующие снапшоты будут удалены по возрасту: $SNAPSHOTS_TO_DELETE_BY_AGE"
    for snapshot in $SNAPSHOTS_TO_DELETE_BY_AGE; do
        sudo timeshift --delete --snapshot "$snapshot"
    done
else
    echo "Нет снапшотов для удаления по возрасту"
fi

# Дополнительная очистка: оставляем не более N последних снапшотов с тегом O И нужным комментарием
echo "Оставляем не более $MAX_SNAPSHOTS последних снапшотов с тегом O и комментарием '$COMMENT_FILTER'..."

SNAPSHOTS_WITH_FILTER=$(timeshift --list --tags O --sort oldest 2>/dev/null | grep "$COMMENT_FILTER")
SNAPSHOTS_COUNT=$(echo "$SNAPSHOTS_WITH_FILTER" | wc -l)

if [ "$SNAPSHOTS_COUNT" -gt "$MAX_SNAPSHOTS" ]; then
    SNAPSHOTS_TO_DELETE_BY_COUNT=$(echo "$SNAPSHOTS_WITH_FILTER" | tail -n +$((MAX_SNAPSHOTS + 1)) | awk '{print $1}')
    echo "Следующие снапшоты будут удалены по количеству: $SNAPSHOTS_TO_DELETE_BY_COUNT"
    for snapshot in $SNAPSHOTS_TO_DELETE_BY_COUNT; do
        sudo timeshift --delete --snapshot "$snapshot"
    done
else
    echo "Нет снапшотов для удаления по количеству (всего $SNAPSHOTS_COUNT штук, лимит — $MAX_SNAPSHOTS)"
fi

