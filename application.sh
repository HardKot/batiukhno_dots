if ! command -v jq &> /dev/null; then
    echo "Installing jq for parsing packages.json..."
    sudo pacman -S --noconfirm jq
fi

PACKAGES_FILE="packages.json"

if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Error: $PACKAGES_FILE not found!"
    exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install pacman packages
echo "Installing pacman packages..."
PACMAN_PKGS=$(jq -r '.pacman[]' "$PACKAGES_FILE" | tr '\n' ' ')
sudo pacman -S --noconfirm $PACMAN_PKGS

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install yay packages
echo "Installing AUR packages..."
YAY_PKGS=$(jq -r '.yay[]' "$PACKAGES_FILE" | tr '\n' ' ')
yay -S --noconfirm $YAY_PKGS



