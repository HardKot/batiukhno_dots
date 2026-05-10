#!/bin/bash

# Функция: получить список всех sinks (ID и имя)
get_sinks() {
    local -n arr=$1
    mapfile -t arr < <(pactl list sinks short | awk '{print $1 " " $2}')
}

# Функция: получить ID текущего default sink
get_default_sink() {
    pactl get-default-sink
}

# Функция: найти индекс sink в массиве по ID
find_index() {
    local -n arr=$1
    local target_id=$2
    for i in "${!arr[@]}"; do
        if [[ "${arr[i]%% *}" == "$target_id" ]]; then
            echo "$i"
            return
        fi
    done
    echo "-1"
}

# Основная логика
main() {
    local sinks=()
    get_sinks sinks

    if [ ${#sinks[@]} -eq 0 ]; then
        echo "Ошибка: не найдено ни одного аудиоустройства (sink)."
        exit 1
    fi

    local default_sink=$(get_default_sink)
    local current_idx=$(find_index sinks "$default_sink")

    if [ "$current_idx" == "-1" ]; then
        echo "Текущий default sink не найден в списке. Переключаю на первый."
        current_idx=0
    fi

    # Вычисляем индекс следующего устройства (по кругу)
    local next_idx=$(( (current_idx + 1) % ${#sinks[@]} ))
    local next_sink_id="${sinks[next_idx]%% *}"

    echo "Текущий выход: $default_sink (индекс $current_idx)"
    echo "Переключаю на: $next_sink_id (индекс $next_idx)"

    # Меняем default sink
    pactl set-default-sink "$next_sink_id"

    echo "Готово. Аудиовыход переключён."
}

# Запуск
main "$@"

