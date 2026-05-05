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

CONFIG_CONNECT = '[[ ! -f \$HOME/Scripts/zsh/config.sh ]] || source $HOME/Scripts/zsh/config.sh'
PLUGINS_CONNECT = 'for plugin in $MY_ZSH_PLUGINS; do plugins+=($plugin); done'
ALIAS_CONNECT = '[[ ! -f $HOME/Scripts/zsh/alias.sh ]] || source $HOME/Scripts/zsh/alias.sh'
VARIABLES_CONNECT = '[[ ! -f $HOME/Scripts/zsh/variables.sh ]] || source $HOME/Scripts/zsh/variables.sh'

if grep -q $CONFIG_CONNECT $HOME/.zshrc; then 
  echo "Конфигурация ZSH уже установленна."
else 
  echo "Установка конфигурации ZSH..."
  set sed -i "3i $CONFIG_CONNECT" $HOME/.zshrc
fi

if grep -q $PLUGINS_CONNECT $HOME/.zshrc; then
    echo "Плагины уже подключены."
else 
    echo "Подключаю плагины"
    sed -i "/^source \$ZSH\/oh-my-zsh\.sh$/i\
    $PLUGINS_CONNECT" $HOME/.zshrc
fi

if grep -q $ALIAS_CONNECT $HOME/.zshrc; then
    echo "Alias уже подключены."
else 
    echo "Подключаю alias"
    echo -e "\n$ALIAS_CONNECT\n" >> $HOME/.zshrc
fi

if grep -q $VARIABLES_CONNECT $HOME/.zshrc; then
    echo "Переменные уже подключены."
else 
    echo "Подключаю переменные"
    echo -e "\n$VARIABLES_CONNECT\n" >> $HOME/.zshrc
fi

if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Смена оболочки на ZSH..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

