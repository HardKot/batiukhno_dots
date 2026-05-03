#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo -e ">> Введите выражение и нажмите Shift+Enter <<\0icon\x1faccessories-calculator"
    exit 0
fi

QUERY="$1"

if [[ "$QUERY" == ">> "* ]]; then
    exit 0
fi

# Если пользователь кликнул по результату, чтобы скопировать его:
if [[ "$QUERY" == "📋 Копировать: "* ]]; then
    RESULT="${QUERY#📋 Копировать: }"
    if command -v xclip >/dev/null 2>&1; then
        printf "%s" "$RESULT" | xclip -selection clipboard
    elif command -v wl-copy >/dev/null 2>&1; then
        printf "%s" "$RESULT" | wl-copy
    fi
    exit 0
fi

# Пробуем вычислить через awk
if RESULT=$(awk "BEGIN {print $QUERY}" 2>/dev/null) && [ -n "$RESULT" ]; then
    echo -e "📋 Копировать: $RESULT\0icon\x1fedit-copy"
else
    echo -e "Ошибка: неверное выражение\0icon\x1fdialog-error"
fi

exit 0