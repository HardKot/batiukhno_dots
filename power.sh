#!/usr/bin/env bash

# Названия пунктов меню
SHUTDOWN="Выключить ПК"
REBOOT="Перезагрузка"
SUSPEND="Сон"
LOGOUT="Выйти из сеанса"

# Если скрипт получил аргумент (пользователь выбрал пункт)
if [ -n "$1" ]; then
    case "$1" in
        "$SHUTDOWN")
            systemctl poweroff
            ;;
        "$REBOOT")
            systemctl reboot
            ;;
        "$SUSPEND")
            systemctl suspend
            ;;
        "$LOGOUT")
            # Надежный способ завершить все процессы пользователя через systemd
            loginctl terminate-user "$USER"
            ;;
    esac
    exit 0
fi

# Если аргументов нет, выводим пункты в Rofi со скрытыми тегами иконок
# Формат: "ТекстПункт\0icon\x1fИмяИконки"
echo -e "$SHUTDOWN\0icon\x1fsystem-shutdown"
echo -e "$REBOOT\0icon\x1fsystem-reboot"
echo -e "$SUSPEND\0icon\x1fsystem-suspend"
echo -e "$LOGOUT\0icon\x1fsystem-log-out"