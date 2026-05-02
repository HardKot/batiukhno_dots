#!/bin/bash

echo -e "${BLUE}=== Настройка Оболочки ZSH"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Установка Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh уже установлен."
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Установка темы Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
    echo "Powerlevel10k уже установлен."
fi

CONFIG_CONNECT = "[[ ! -f $HOME/Scripts/zsh.sh ]] || source $HOME/Scripts/zsh.sh"
if grep -q CONFIG_CONNECT $HOME/.zshrc; then 
  echo "Конфигурация ZSH уже установленна."
else 
  echo "Установка конфигурации ZSH..."
  set sed -i '3i [[ ! -f $HOME/Scripts/zsh.sh ]] || source $HOME/Scripts/zsh.sh' $HOME/.zshrc
fi

PLUGINS_INSTALL = "for plugin in $MY_ZSH_PLUGINS; do plugins+=($plugin); done"

if grep -q PLUGINS_INSTALL $HOME/.zshrc; then
    echo "Плагины уже подключены."
else 
    echo "Подключаю плагины"
    sed -i '/^source \$ZSH\/oh-my-zsh\.sh$/i\
    for plugin in $MY_ZSH_PLUGINS; do plugins+=($plugin); done' $HOME/.zshrc
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Смена оболочки на ZSH..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

