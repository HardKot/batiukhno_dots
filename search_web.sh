#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo -e ">> Введите запрос и нажмите Shift+Enter <<\0icon\x1fweb-browser"
    echo -e ">> (Префиксы: yt:, go:, ya: или без префикса для Yandex) <<\0icon\x1fhelp-about"
    exit 0
fi

QUERY="$1"

if [[ "$QUERY" == ">> "* ]]; then
    exit 0
fi

if [[ "$QUERY" == yt:* ]]; then
    SEARCH_TERM="${QUERY#yt:}"
    SEARCH_TERM="${SEARCH_TERM// /+}"
    xdg-open "https://www.youtube.com/results?search_query=$SEARCH_TERM" >/dev/null 2>&1
elif [[ "$QUERY" == go:* ]]; then
    SEARCH_TERM="${QUERY#go:}"
    SEARCH_TERM="${SEARCH_TERM// /+}"
    xdg-open "https://www.google.com/search?q=$SEARCH_TERM" >/dev/null 2>&1
elif [[ "$QUERY" == ya:* ]]; then
    SEARCH_TERM="${QUERY#ya:}"
    SEARCH_TERM="${SEARCH_TERM// /+}"
    xdg-open "https://yandex.ru/search/?text=$SEARCH_TERM" >/dev/null 2>&1
else
    # Если префикса нет, ищем в Яндексе по всему запросу
    SEARCH_TERM="${QUERY// /+}"
    xdg-open "https://yandex.ru/search/?text=$SEARCH_TERM" >/dev/null 2>&1
fi

exit 0