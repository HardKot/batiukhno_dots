echo "Обновление системы..."
sudo pacman -Syu --noconfirm

if ! command -v yq &> /dev/null; then
    echo "Установка yq для парсинга config.yaml..."
    sudo pacman -S --noconfirm yq
fi

PACKAGES_FILE="config.yaml"

if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: $PACKAGES_FILE не найден!"
    exit 1
fi

echo "Установка пакетов pacman..."
PACMAN_PKGS=$(yq '.pacman[]' "$PACKAGES_FILE" | tr '\n' ' ')
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
YAY_PKGS=$(yq '.yay[]' "$PACKAGES_FILE" | tr '\n' ' ')
yay -S --noconfirm $YAY_PKGS

echo "Выполнение bash команд из config.yaml..."
BASH_CMDS=$(yq '.bash[]' "$PACKAGES_FILE")
while IFS= read -r cmd; do
    echo "Выполнение: $cmd"
    eval "$cmd"
done <<< "$BASH_CMDS"