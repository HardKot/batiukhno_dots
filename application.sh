echo "Обновление системы..."
sudo pacman -Syu --noconfirm

if ! command -v jq &> /dev/null; then
    echo "Установка jq для парсинга packages.json..."
    sudo pacman -S --noconfirm jq
fi

PACKAGES_FILE="packages.json"

if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: $PACKAGES_FILE не найден!"
    exit 1
fi

echo "Установка пакетов pacman..."
PACMAN_PKGS=$(jq -r '.pacman[]' "$PACKAGES_FILE" | tr '\n' ' ')
sudo pacman -S --noconfirm $PACMAN_PKGS

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "Установка yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install yay packages
echo "Установка AUR пакетов..."
YAY_PKGS=$(jq -r '.yay[]' "$PACKAGES_FILE" | tr '\n' ' ')
yay -S --noconfirm $YAY_PKGS

echo "Выполнение bash команд из packages.json..."
BASH_CMDS=$(jq -r '.bash[]' "$PACKAGES_FILE")
while IFS= read -r cmd; do
    echo "Выполнение: $cmd"
    eval "$cmd"
done <<< "$BASH_CMDS"