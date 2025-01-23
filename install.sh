pacman -S --noconfirm base-devel

echo "Install Tools"
pacman -S --no confirm \
  nvim \
  kitty \

ln -s nvim ${HOME}/.config/nvim
ln -s kitty ${HOME}/.config/kitty

echo "Copy wallpaper"
ln -s wallpaper ${HOME}/wallpaper

echo "Install WM"
pacman -S --noconfirm \
  hyprland \
  hyprpicker \
  hyprpaper \
  waybar \
  rofi-wayland \

ln -s hypr ${HOME}/.config/hypr
ln -s waybar ${HOME}/.config/waybar

echo "Install system utils"
pacman -S --noconfirm \
  ddccontrol \
  rocm-core \
  jdtls \
  tar \
  curl

echo "Install other soft"
pacman -S --noconfirm \
  telegram-desktop \
  firefox \
  keepassxc \
  syncthing 


echo "Install fonts"
curl -L -o https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.tar.xz

curl -L -o https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Noto.tar.xz

tar -xzvf JetBrainsMono.tar.xz

tar -xzvf Noto.tar.xz

font_dir = ${HOME}/.local/share/fonts

mkdir "${font_dir}"

mv JetBrainsMono/JetBrainsMonoNerdFontMono-* "${font_dir}"
mv Noto/NotoSansNerdFontProto-* Noto/NotoSerifNerdFont-* "${font_dir}"

rm -rf JetBrainsMono Noto 
fc-cache -f -v
