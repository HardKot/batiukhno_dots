#!/usr/bin/env bash
set -e

CONFIG="configuration.json"
PACKAGES="packages.json"

# Проверка наличия jq
if ! command -v jq &> /dev/null; then
    echo "❌ Для работы нужен 'jq'. Устанавливаю..."
    sudo pacman -S --noconfirm jq
fi

echo "🚀 Начинаем применение конфигурации системы..."

# --- 1. СИСТЕМНЫЕ НАСТРОЙКИ ---
echo "⚙️  Проверка базовых настроек системы..."
HOSTNAME=$(jq -r '.system.hostname' "$CONFIG")
CURRENT_HOSTNAME=$(cat /etc/hostname 2>/dev/null || echo "")

if [[ "$CURRENT_HOSTNAME" != "$HOSTNAME" && "$HOSTNAME" != "null" ]]; then
    echo "🔄 Изменение hostname на $HOSTNAME..."
    sudo hostnamectl set-hostname "$HOSTNAME"
fi

TIMEZONE=$(jq -r '.system.timezone' "$CONFIG")
if [[ "$TIMEZONE" != "null" ]]; then
    CURRENT_TIMEZONE=$(timedatectl show -p Timezone --value 2>/dev/null)
    if [[ "$CURRENT_TIMEZONE" != "$TIMEZONE" ]]; then
        echo "🕒 Установка часового пояса $TIMEZONE..."
        sudo timedatectl set-timezone "$TIMEZONE"
    fi
fi

# --- 2. УСТАНОВКА ПАКЕТОВ ИЗ PACKAGES.JSON ---
echo "📦 Проверка и установка пакетов..."

# Pacman
readarray -t PACMAN_PKGS < <(jq -r '.pacman[]' "$PACKAGES")
if [[ ${#PACMAN_PKGS[@]} -gt 0 ]]; then
    INSTALLED_PACMAN=$(pacman -Qq)
    MISSING_PACMAN=()
    for pkg in "${PACMAN_PKGS[@]}"; do
        if ! grep -q "^$pkg$" <<< "$INSTALLED_PACMAN"; then
            MISSING_PACMAN+=("$pkg")
        fi
    done

    if [[ ${#MISSING_PACMAN[@]} -gt 0 ]]; then
        echo "📥 Установка пакетов pacman: ${MISSING_PACMAN[*]}"
        sudo pacman -S --noconfirm --needed "${MISSING_PACMAN[@]}"
    else
        echo "✅ Пакеты pacman актуальны."
    fi
fi

# Yay (AUR)
readarray -t YAY_PKGS < <(jq -r '.yay[]' "$PACKAGES")
if [[ ${#YAY_PKGS[@]} -gt 0 ]]; then
    if ! command -v yay &> /dev/null; then
        echo "⚠️  yay не установлен. Установка yay..."
        sudo pacman -S --needed --noconfirm git base-devel
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
    fi

    INSTALLED_YAY=$(pacman -Qq)
    MISSING_YAY=()
    for pkg in "${YAY_PKGS[@]}"; do
        if ! grep -q "^$pkg$" <<< "$INSTALLED_YAY"; then
            MISSING_YAY+=("$pkg")
        fi
    done

    if [[ ${#MISSING_YAY[@]} -gt 0 ]]; then
        echo "📥 Установка AUR пакетов: ${MISSING_YAY[*]}"
        yay -S --noconfirm --needed "${MISSING_YAY[@]}"
    else
        echo "✅ Пакеты AUR актуальны."
    fi
fi

# Bash scripts
readarray -t BASH_SCRIPTS < <(jq -r '.bash[]' "$PACKAGES")
if [[ ${#BASH_SCRIPTS[@]} -gt 0 ]]; then
    echo "📜 Внимание: bash-скрипты не идемпотентны. Выполнять повторно?"
    # Здесь можно добавить логику отслеживания (например, создавать файлы-маркеры)
    # Пока просто выводим, так как они уже есть в вашем packages.json
fi

# --- 3. ЗАПУСК МОДУЛЕЙ ---
echo "🧩 Выполнение модулей настройки..."

if [[ "$(jq -r '.modules.dotfiles' "$CONFIG")" == "true" ]]; then
    if [[ -f "./setup_dots.sh" ]]; then
        echo "➡️  Запуск setup_dots.sh"
        bash ./setup_dots.sh
    else
        echo "⚠️  Файл setup_dots.sh не найден."
    fi
fi

if [[ "$(jq -r '.modules.zsh' "$CONFIG")" == "true" ]]; then
    if [[ -f "./zsh_config.sh" ]]; then
         echo "➡️  Запуск zsh_config.sh"
         bash ./zsh_config.sh
    fi
    
    # Меняем shell пользователю
    TARGET_SHELL=$(jq -r '.users.shell' "$CONFIG")
    USERNAME=$(jq -r '.users.main_user' "$CONFIG")
    CURRENT_SHELL=$(getent passwd "$USERNAME" | cut -d: -f7)
    
    if [[ "$CURRENT_SHELL" != "$TARGET_SHELL" && "$TARGET_SHELL" != "null" ]]; then
        echo "🐚 Изменение оболочки для $USERNAME на $TARGET_SHELL..."
        sudo chsh -s "$TARGET_SHELL" "$USERNAME"
    fi
fi

# --- 4. ПРИМЕНЕНИЕ СЛУЖБ (SYSTEMD) ---
echo "⚙️  Проверка служб Systemd..."

# Системные
readarray -t SYS_SERVICES < <(jq -r '.services.system.enable[]' "$CONFIG")
for svc in "${SYS_SERVICES[@]}"; do
    if ! systemctl is-enabled --quiet "$svc" 2>/dev/null; then
        echo "🔌 Включение ($svc)..."
        sudo systemctl enable --now "$svc"
    fi
done

# Пользовательские
readarray -t USER_SERVICES < <(jq -r '.services.user.enable[]' "$CONFIG")
for svc in "${USER_SERVICES[@]}"; do
    if ! systemctl --user is-enabled --quiet "$svc" 2>/dev/null; then
        echo "🔌 Включение пользовательской службы ($svc)..."
        systemctl --user enable --now "$svc"
    fi
done

echo "🎉 Конфигурация успешно применена (Идемпотентно)!"
